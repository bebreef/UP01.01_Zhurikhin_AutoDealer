using System;
using System.Data.Entity;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    public partial class DealEditPage : Page
    {
        private readonly int? dealId;
        private Deals original;
        private bool loaded;

        public DealEditPage() : this(null)
        {
        }

        public DealEditPage(int? id)
        {
            InitializeComponent();
            dealId = id;
            Title = id.HasValue ? "Сделка №" + id.Value : "Добавление сделки";
            HeadingText.Text = Title;
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            if (loaded || Core.CurrentUser == null)
                return;
            try
            {
                if (dealId.HasValue)
                {
                    original = Core.Context.Deals.AsNoTracking().SingleOrDefault(x => x.DealID == dealId.Value);
                    if (original == null)
                        throw new InvalidOperationException();
                }
                string vin = original == null ? null : original.VIN;
                CarBox.ItemsSource = Core.Context.Cars.AsNoTracking().Where(x => x.Status == "На складе" || x.VIN == vin).OrderBy(x => x.Brand).ThenBy(x => x.Model).ToList();
                ClientBox.ItemsSource = Core.Context.Clients.AsNoTracking().OrderBy(x => x.FullName).ToList();
                EmployeeBox.ItemsSource = Core.Context.Employees.AsNoTracking().OrderBy(x => x.FullName).ToList();
                StatusBox.ItemsSource = original != null && original.ContractStatus == "Зарезервирован"
                    ? new[] { "Зарезервирован", "Исполнен", "Отменен" }
                    : new[] { "Черновик", "Зарезервирован", "Исполнен", "Отменен" };
                if (original == null)
                {
                    EmployeeBox.SelectedValue = Core.CurrentUser.EmployeeID;
                    DealDatePicker.SelectedDate = DateTime.Today;
                    StatusBox.SelectedItem = "Черновик";
                }
                else
                {
                    CarBox.SelectedValue = original.VIN;
                    ClientBox.SelectedValue = original.ClientID;
                    EmployeeBox.SelectedValue = original.EmployeeID;
                    DealDatePicker.SelectedDate = original.DealDate;
                    PriceBox.Text = original.FinalPrice.ToString("F2", CultureInfo.GetCultureInfo("ru-RU"));
                    StatusBox.SelectedItem = original.ContractStatus;
                    CarBox.IsEnabled = original.ContractStatus == "Черновик";
                }
                bool editable = Core.CanEditData() && (original == null || original.ContractStatus == "Черновик" || original.ContractStatus == "Зарезервирован");
                EditorPanel.IsEnabled = editable;
                SaveButton.Visibility = editable ? Visibility.Visible : Visibility.Collapsed;
                if (!editable)
                    HintText.Text = "Просмотр договора. Изменение недоступно для вашей роли либо договор уже исполнен или отменён.";
                loaded = true;
            }
            catch (Exception)
            {
                EditorPanel.IsEnabled = false;
                SaveButton.IsEnabled = false;
                MessageBox.Show("Не удалось загрузить сделку или справочники. Вернитесь к списку и обновите данные.", "Сделки", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        private void CarBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            var car = CarBox.SelectedItem as Cars;
            if (loaded && car != null)
                PriceBox.Text = car.Price.ToString("F2", CultureInfo.GetCultureInfo("ru-RU"));
        }

        private void Price_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !Regex.IsMatch(e.Text, "^[0-9.,]+$");
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (!loaded || !Core.CanEditData() || !EditorPanel.IsEnabled)
                return;
            var car = CarBox.SelectedItem as Cars;
            var client = ClientBox.SelectedItem as Clients;
            var employee = EmployeeBox.SelectedItem as Employees;
            string status = StatusBox.SelectedItem as string;
            string priceText = PriceBox.Text.Trim().Replace(',', '.');
            decimal price;
            var errors = new StringBuilder();
            if (car == null) errors.AppendLine("Выберите автомобиль.");
            if (client == null) errors.AppendLine("Выберите клиента.");
            if (employee == null) errors.AppendLine("Выберите сотрудника.");
            if (!DealDatePicker.SelectedDate.HasValue || DealDatePicker.SelectedDate.Value < new DateTime(1753, 1, 1))
                errors.AppendLine("Укажите корректную дату, не ранее 01.01.1753.");
            if (!decimal.TryParse(priceText, NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture, out price) || price <= 0 || price > 9999999999.99m || !Regex.IsMatch(priceText, @"^[0-9]+(\.[0-9]{1,2})?$"))
                errors.AppendLine("Сумма должна быть от 0,01 до 9 999 999 999,99, до двух знаков после запятой.");
            if (status == null) errors.AppendLine("Выберите статус.");
            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString(), "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            if ((status == "Исполнен" || status == "Отменен") && MessageBox.Show("Сохранить статус «" + status + "»? После этого договор нельзя будет изменить или удалить.", "Подтверждение статуса", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                return;
            Deals deal = null;
            SaveButton.IsEnabled = false;
            try
            {
                using (var transaction = Core.Context.Database.BeginTransaction(System.Data.IsolationLevel.Serializable))
                {
                    if (dealId.HasValue)
                    {
                        deal = Core.Context.Deals.SingleOrDefault(x => x.DealID == dealId.Value);
                        if (deal == null) throw new InvalidOperationException();
                        Core.Context.Entry(deal).Reload();
                        if (deal.ContractStatus != original.ContractStatus || deal.VIN != original.VIN || deal.ClientID != original.ClientID || deal.EmployeeID != original.EmployeeID || deal.DealDate != original.DealDate || deal.FinalPrice != original.FinalPrice)
                        {
                            MessageBox.Show("Сделку уже изменили. Откройте её заново из списка.", "Сохранение", MessageBoxButton.OK, MessageBoxImage.Warning);
                            return;
                        }
                    }
                    else
                    {
                        deal = new Deals();
                        Core.Context.Deals.Add(deal);
                    }
                    deal.VIN = car.VIN;
                    deal.ClientID = client.ClientID;
                    deal.EmployeeID = employee.EmployeeID;
                    deal.DealDate = DealDatePicker.SelectedDate.Value;
                    deal.FinalPrice = price;
                    deal.ContractStatus = status;
                    Core.Context.SaveChanges();
                    transaction.Commit();
                }
                Core.Context.Entry(deal).State = EntityState.Detached;
                MessageBox.Show("Сделка сохранена.", "Сохранение", MessageBoxButton.OK, MessageBoxImage.Information);
                ReturnToList();
            }
            catch (Exception)
            {
                if (deal != null)
                    Core.Context.Entry(deal).State = EntityState.Detached;
                MessageBox.Show("Не удалось сохранить сделку. Автомобиль мог стать недоступен, договор или справочники могли измениться. Проверьте подключение и откройте форму заново.", "Сохранение", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
            finally
            {
                SaveButton.IsEnabled = true;
            }
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            ReturnToList();
        }

        private void ReturnToList()
        {
            if (NavigationService.CanGoBack)
                NavigationService.GoBack();
            else
                NavigationService.Navigate(new DealsPage());
        }
    }
}
