using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Forms.DataVisualization.Charting;
using System.Windows.Media.Imaging;
using Microsoft.Win32;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    public class SalesReportRow
    {
        public string Month { get; set; }
        public int Count { get; set; }
        public decimal Amount { get; set; }
    }

    public partial class ReportsPage : Page
    {
        private List<SalesReportRow> rows = new List<SalesReportRow>();
        private string reportDescription;
        private byte[] chartBytes;
        private bool loaded;

        public ReportsPage() { InitializeComponent(); }

        private bool CanView()
        {
            string role = Core.CurrentUser?.Roles?.RoleName;
            return role == "Администратор" || role == "Руководитель";
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            ContentPanel.IsEnabled = CanView();
            if (!CanView() || loaded) return;
            try
            {
                var employees = Core.Context.Employees.AsNoTracking().OrderBy(x => x.FullName).ToList();
                employees.Insert(0, new Employees { EmployeeID = 0, FullName = "Все сотрудники" });
                EmployeeBox.ItemsSource = employees;
                EmployeeBox.SelectedIndex = 0;
                FromPicker.SelectedDate = Core.Context.Deals.Select(x => (DateTime?)x.DealDate).Min()?.Date ?? new DateTime(DateTime.Today.Year, 1, 1);
                ToPicker.SelectedDate = DateTime.Today;
                loaded = true;
                GenerateReport();
            }
            catch (Exception) { SummaryText.Text = "Не удалось загрузить данные. Откройте страницу заново."; }
        }

        private void GenerateButton_Click(object sender, RoutedEventArgs e) { GenerateReport(); }

        private void GenerateReport()
        {
            if (!CanView()) return;
            if (!FromPicker.SelectedDate.HasValue || !ToPicker.SelectedDate.HasValue || FromPicker.SelectedDate > ToPicker.SelectedDate || FromPicker.SelectedDate.Value.Year < 1753)
            { MessageBox.Show("Укажите корректный период: начало не позже конца, даты от 01.01.1753.", "Отчёты"); return; }
            var employee = EmployeeBox.SelectedItem as Employees;
            if (employee == null) return;
            ExportPanel.IsEnabled = false;
            try
            {
                DateTime from = FromPicker.SelectedDate.Value.Date;
                DateTime to = ToPicker.SelectedDate.Value.Date;
                var query = Core.Context.Deals.AsNoTracking().Where(x => x.ContractStatus == "Исполнен" && x.DealDate >= from);
                if (to < DateTime.MaxValue.Date)
                {
                    DateTime end = to.AddDays(1);
                    query = query.Where(x => x.DealDate < end);
                }
                if (employee.EmployeeID != 0) query = query.Where(x => x.EmployeeID == employee.EmployeeID);
                rows = query.ToList().GroupBy(x => new { x.DealDate.Year, x.DealDate.Month }).OrderBy(x => x.Key.Year).ThenBy(x => x.Key.Month)
                    .Select(x => new SalesReportRow { Month = x.Key.Month.ToString("00") + "." + x.Key.Year, Count = x.Count(), Amount = x.Sum(d => d.FinalPrice) }).ToList();
                reportDescription = "Период: " + from.ToString("dd.MM.yyyy") + " — " + to.ToString("dd.MM.yyyy") + ". Сотрудник: " + employee.FullName + ". Только исполненные сделки.";
                SummaryText.Text = reportDescription + " Продаж: " + rows.Sum(x => x.Count) + ". Сумма: " + rows.Sum(x => x.Amount).ToString("N2") + " ₽.";
                if (rows.Count == 0) SummaryText.Text += " За этот период продаж нет.";
                ReportGrid.ItemsSource = rows;
                DrawChart();
                ExportPanel.IsEnabled = true;
            }
            catch (Exception)
            {
                rows.Clear(); ReportGrid.ItemsSource = null; ChartImage.Source = null; chartBytes = null;
                SummaryText.Text = "Не удалось сформировать отчёт. Проверьте подключение и повторите попытку.";
            }
        }

        private void ChartType_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (loaded && reportDescription != null) DrawChart();
        }

        private void DrawChart()
        {
            using (var chart = new Chart { Width = 1000, Height = 550, BackColor = Color.White })
            {
                var area = new ChartArea("Sales");
                area.AxisX.Interval = 1;
                area.AxisY.LabelStyle.Format = "N0";
                area.AxisY.Title = "Сумма, ₽";
                area.AxisX.MajorGrid.Enabled = false;
                area.AxisY.MajorGrid.LineColor = Color.LightGray;
                chart.ChartAreas.Add(area);
                chart.Titles.Add(rows.Count == 0 ? "Нет продаж за выбранный период" : "Продажи по месяцам, ₽");
                var series = new Series("Продажи") { ChartType = ChartTypeBox.SelectedIndex == 1 ? SeriesChartType.Line : ChartTypeBox.SelectedIndex == 2 ? SeriesChartType.Pie : SeriesChartType.Column, IsValueShownAsLabel = true, LabelFormat = "N0", BorderWidth = 3 };
                foreach (var row in rows) series.Points.AddXY(row.Month, row.Amount);
                chart.Series.Add(series);
                using (var stream = new MemoryStream())
                {
                    chart.SaveImage(stream, ChartImageFormat.Png);
                    chartBytes = stream.ToArray();
                    stream.Position = 0;
                    var image = new BitmapImage();
                    image.BeginInit(); image.CacheOption = BitmapCacheOption.OnLoad; image.StreamSource = stream; image.EndInit(); image.Freeze();
                    ChartImage.Source = image;
                }
            }
        }

        private void ExportButton_Click(object sender, RoutedEventArgs e)
        {
            if (!CanView() || chartBytes == null) return;
            string extension = (string)((Button)sender).Tag;
            var dialog = new SaveFileDialog { Filter = extension.ToUpperInvariant() + "|*." + extension, DefaultExt = extension, FileName = "Продажи_" + DateTime.Today.ToString("yyyy-MM-dd"), OverwritePrompt = true };
            if (dialog.ShowDialog() != true) return;
            try
            {
                ExportPanel.IsEnabled = false;
                SalesReportExport.Save(dialog.FileName, extension, reportDescription, rows, chartBytes);
                MessageBox.Show("Отчёт сохранён: " + dialog.FileName, "Экспорт", MessageBoxButton.OK, MessageBoxImage.Information);
            }
            catch (Exception) { MessageBox.Show("Не удалось сохранить отчёт. Проверьте наличие Microsoft Word/Excel, доступ к папке и закройте файл, если он открыт.", "Экспорт", MessageBoxButton.OK, MessageBoxImage.Warning); }
            finally { ExportPanel.IsEnabled = true; }
        }
    }

    public static class SalesReportExport
    {
        public static void Save(string path, string extension, string description, List<SalesReportRow> rows, byte[] chart)
        {
            string picture = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString("N") + ".png");
            File.WriteAllBytes(picture, chart);
            try
            {
                if (extension == "xlsx") SaveExcel(path, description, rows, picture);
                else SaveWord(path, extension, description, rows, picture);
            }
            finally { if (File.Exists(picture)) File.Delete(picture); }
        }

        private static void SaveWord(string path, string extension, string description, List<SalesReportRow> rows, string picture)
        {
            dynamic app = null;
            dynamic document = null;
            try
            {
                app = Activator.CreateInstance(Type.GetTypeFromProgID("Word.Application"));
                app.Visible = false;
                app.DisplayAlerts = 0;
                document = app.Documents.Add();
                document.Content.Font.Name = "Arial";
                document.Content.Font.Size = 11;
                document.Content.Text = "Автодилерский центр — отчёт по продажам\r" + description + "\rПродаж: " + rows.Sum(x => x.Count) + ". Сумма: " + rows.Sum(x => x.Amount).ToString("N2", CultureInfo.GetCultureInfo("ru-RU")) + " руб.\r\r";
                document.Paragraphs[1].Range.Font.Size = 16;
                document.Paragraphs[1].Range.Font.Bold = 1;
                dynamic range = document.Range(document.Content.End - 1, document.Content.End - 1);
                dynamic table = document.Tables.Add(range, rows.Count + 2, 3);
                table.Borders.Enable = 1;
                table.Rows[1].HeadingFormat = -1;
                table.Rows[1].Range.Bold = 1;
                table.Cell(1, 1).Range.Text = "Месяц"; table.Cell(1, 2).Range.Text = "Продажи"; table.Cell(1, 3).Range.Text = "Сумма, руб.";
                for (int i = 0; i < rows.Count; i++)
                {
                    table.Cell(i + 2, 1).Range.Text = rows[i].Month;
                    table.Cell(i + 2, 2).Range.Text = rows[i].Count.ToString();
                    table.Cell(i + 2, 3).Range.Text = rows[i].Amount.ToString("N2", CultureInfo.GetCultureInfo("ru-RU"));
                }
                int total = rows.Count + 2;
                table.Cell(total, 1).Range.Text = "Итого";
                table.Cell(total, 2).Range.Text = rows.Sum(x => x.Count).ToString();
                table.Cell(total, 3).Range.Text = rows.Sum(x => x.Amount).ToString("N2", CultureInfo.GetCultureInfo("ru-RU"));
                table.Rows[total].Range.Bold = 1;
                table.Rows.AllowBreakAcrossPages = 0;
                document.Paragraphs.Add();
                dynamic end = document.Range(document.Content.End - 1, document.Content.End - 1);
                dynamic image = document.InlineShapes.AddPicture(picture, false, true, end);
                image.LockAspectRatio = -1;
                image.Width = 450;
                if (extension == "pdf") document.ExportAsFixedFormat(path, 17);
                else document.SaveAs2(path, 16);
            }
            finally
            {
                try { if ((object)document != null) { object savedDocument = document; document.Close(false); Marshal.FinalReleaseComObject(savedDocument); } }
                finally { if ((object)app != null) { object savedApp = app; app.Quit(); Marshal.FinalReleaseComObject(savedApp); } }

            }
        }

        private static void SaveExcel(string path, string description, List<SalesReportRow> rows, string picture)
        {
            dynamic app = null;
            dynamic book = null;
            try
            {
                app = Activator.CreateInstance(Type.GetTypeFromProgID("Excel.Application"));
                app.Visible = false;
                app.DisplayAlerts = false;
                book = app.Workbooks.Add();
                dynamic sheet = book.Worksheets[1];
                sheet.Name = "Продажи";
                sheet.Cells[1, 1] = "Автодилерский центр — продажи";
                sheet.Range["A1:C1"].Merge(); sheet.Range["A1"].Font.Bold = true; sheet.Range["A1"].Font.Size = 16;
                sheet.Cells[2, 1] = description; sheet.Range["A2:C2"].Merge(); sheet.Range["A2"].WrapText = true; sheet.Rows[2].RowHeight = 60;
                sheet.Cells[4, 1] = "Месяц"; sheet.Cells[4, 2] = "Продажи"; sheet.Cells[4, 3] = "Сумма, руб.";
                sheet.Range["A4:C4"].Font.Bold = true;
                sheet.Columns[1].NumberFormat = "@";
                for (int i = 0; i < rows.Count; i++)
                {
                    sheet.Cells[i + 5, 1] = rows[i].Month;
                    sheet.Cells[i + 5, 2] = rows[i].Count;
                    sheet.Cells[i + 5, 3] = (double)rows[i].Amount;
                }
                int total = rows.Count + 5;
                sheet.Cells[total, 1] = "Итого";
                sheet.Cells[total, 2].Formula = rows.Count == 0 ? "=0" : "=SUM(B5:B" + (total - 1) + ")";
                sheet.Cells[total, 3].Formula = rows.Count == 0 ? "=0" : "=SUM(C5:C" + (total - 1) + ")";
                sheet.Range["A" + total + ":C" + total].Font.Bold = true;
                sheet.Range["C5:C" + total].NumberFormatLocal = "#" + (string)app.International[4] + "##0" + (string)app.International[3] + "00";
                sheet.Range["A4:C" + total].Borders.LineStyle = 1;
                sheet.Columns[1].ColumnWidth = 20; sheet.Columns[2].ColumnWidth = 16; sheet.Columns[3].ColumnWidth = 24;
                sheet.Shapes.AddPicture(picture, 0, -1, 450, 20, 600, 330);
                book.SaveAs(path, 51);
            }
            finally
            {
                try { if ((object)book != null) { object savedBook = book; book.Close(false); Marshal.FinalReleaseComObject(savedBook); } }
                finally { if ((object)app != null) { object savedApp = app; app.Quit(); Marshal.FinalReleaseComObject(savedApp); } }

            }
        }
    }
}
