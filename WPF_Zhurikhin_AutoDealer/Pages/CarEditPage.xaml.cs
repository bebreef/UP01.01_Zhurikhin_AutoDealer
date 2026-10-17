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
    public partial class CarEditPage : Page
    {
        private readonly string originalVin;
        private bool loaded;
        private string originalStatus;

        public CarEditPage(string vin)
        {
            InitializeComponent();
            originalVin = vin;
            Title = vin == null ? "Добавление автомобиля" : "Редактирование автомобиля";
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            if (!Core.CanEditData())
            {
                EditorPanel.IsEnabled = false;
                return;
            }
            if (loaded)
                return;

            StatusBox.ItemsSource = new[] { "На складе", "В пути", "На диагностике" };
            StatusBox.SelectedIndex = 0;
            YearBox.Text = DateTime.Now.Year.ToString();
            MileageBox.Text = "0";
            if (originalVin == null)
            {
                loaded = true;
                return;
            }
            try
            {
                var car = Core.Context.Cars.AsNoTracking().SingleOrDefault(x => x.VIN == originalVin);
                if (car == null)
                {
                    EditorPanel.IsEnabled = false;
                    MessageBox.Show("Автомобиль не найден. Вернитесь к списку и обновите его.", "Автомобиль", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                VinBox.Text = car.VIN;
                VinBox.IsReadOnly = true;
                BrandBox.Text = car.Brand;
                ModelBox.Text = car.Model;
                YearBox.Text = car.Year.ToString();
                ColorBox.Text = car.Color;
                MileageBox.Text = car.Kilomitrage.ToString();
                PriceBox.Text = car.Price.ToString("F2", CultureInfo.GetCultureInfo("ru-RU"));
                if (car.Status == "Продан" || car.Status == "Зарезервирован")
                {
                    StatusBox.ItemsSource = new[] { car.Status };
                    StatusBox.IsEnabled = false;
                    StatusHint.Text = "Статус связан с договором. Изменять его нужно на странице сделок.";
                }
                StatusBox.SelectedItem = car.Status;
                originalStatus = car.Status;
                loaded = true;
            }
            catch (Exception)
            {
                EditorPanel.IsEnabled = false;
                MessageBox.Show("Не удалось загрузить автомобиль. Вернитесь к списку и повторите попытку.", "Автомобиль", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        private void Integer_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !Regex.IsMatch(e.Text, "^[0-9]+$");
        }

        private void Price_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !Regex.IsMatch(e.Text, "^[0-9.,]+$");
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (!Core.CanEditData() || !loaded)
                return;

            string vin = VinBox.Text.Trim().ToUpperInvariant();
            string brand = BrandBox.Text.Trim();
            string model = ModelBox.Text.Trim();
            string color = ColorBox.Text.Trim();
            string status = StatusBox.SelectedItem as string;
            string priceText = PriceBox.Text.Trim().Replace(',', '.');
            int year;
            int mileage;
            decimal price;
            var errors = new StringBuilder();
            if (!Regex.IsMatch(vin, "^[A-HJ-NPR-Z0-9]{17}$"))
                errors.AppendLine("VIN должен содержать ровно 17 латинских букв и цифр, без I, O и Q.");
            if (brand.Length == 0 || brand.Length > 50)
                errors.AppendLine("Укажите марку длиной до 50 символов.");
            if (model.Length == 0 || model.Length > 50)
                errors.AppendLine("Укажите модель длиной до 50 символов.");
            if (color.Length > 30)
                errors.AppendLine("Цвет должен содержать до 30 символов.");
            if (!int.TryParse(YearBox.Text, out year) || year < 1886 || year > 2100)
                errors.AppendLine("Год должен быть целым числом от 1886 до 2100.");
            if (!int.TryParse(MileageBox.Text, out mileage) || mileage < 0)
                errors.AppendLine("Пробег должен быть целым числом от 0 до 2 147 483 647.");
            if (!decimal.TryParse(priceText, NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture, out price) || price <= 0 || price > 9999999999.99m || !Regex.IsMatch(priceText, "^[0-9]+(\\.[0-9]{1,2})?$"))
                errors.AppendLine("Цена должна быть от 0,01 до 9 999 999 999,99, не более двух знаков после запятой.");
            if (status == null)
                errors.AppendLine("Выберите статус.");
            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString(), "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            Cars car = null;
            SaveButton.IsEnabled = false;
            try
            {
                if (originalVin == null)
                {
                    if (Core.Context.Cars.Any(x => x.VIN == vin))
                    {
                        MessageBox.Show("Автомобиль с таким VIN уже существует.", "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning);
                        return;
                    }
                    car = new Cars { VIN = vin };
                    Core.Context.Cars.Add(car);
                }
                else
                {
                    car = Core.Context.Cars.SingleOrDefault(x => x.VIN == originalVin);
                    if (car == null)
                    {
                        MessageBox.Show("Автомобиль уже удалён. Вернитесь к списку.", "Сохранение", MessageBoxButton.OK, MessageBoxImage.Warning);
                        return;
                    }
                    Core.Context.Entry(car).Reload();
                    if (car.Status != originalStatus)
                    {
                        Core.Context.Entry(car).State = EntityState.Detached;
                        MessageBox.Show("Статус автомобиля уже изменился. Откройте его заново из списка.", "Сохранение", MessageBoxButton.OK, MessageBoxImage.Warning);
                        return;
                    }
                    if (car.Status == "Продан" || car.Status == "Зарезервирован")
                        status = car.Status;
                }
                car.Brand = brand;
                car.Model = model;
                car.Year = year;
                car.Color = color.Length == 0 ? null : color;
                car.Kilomitrage = mileage;
                car.Price = price;
                car.Status = status;
                Core.Context.SaveChanges();
                Core.Context.Entry(car).State = EntityState.Detached;
                MessageBox.Show("Автомобиль сохранён.", "Сохранение", MessageBoxButton.OK, MessageBoxImage.Information);
                ReturnToList();
            }
            catch (Exception)
            {
                if (car != null)
                    Core.Context.Entry(car).State = EntityState.Detached;
                MessageBox.Show("Не удалось сохранить автомобиль. Проверьте подключение, уникальность VIN и статус связанного договора. Затем обновите данные.", "Сохранение", MessageBoxButton.OK, MessageBoxImage.Warning);
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
                NavigationService.Navigate(new CarsPage());
        }
    }
}
