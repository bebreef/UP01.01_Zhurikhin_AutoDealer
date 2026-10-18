using System;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    public partial class BuyCarPage : Page
    {
        private readonly string vin;
        private decimal shownPrice;
        private bool loaded;
        private bool submitted;

        public BuyCarPage(string selectedVin)
        {
            InitializeComponent();
            vin = selectedVin;
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            if (!Core.IsCustomer() || submitted) { FormPanel.IsEnabled = false; return; }
            if (loaded) return;
            try
            {
                var car = Core.Context.Cars.AsNoTracking().SingleOrDefault(x => x.VIN == vin);
                if (car == null || car.Status != "На складе")
                {
                    BuyButton.IsEnabled = false;
                    MessageBox.Show("Автомобиль больше недоступен для покупки. Вернитесь в каталог и обновите список.", "Покупка");
                    return;
                }
                shownPrice = car.Price;
                CarText.Text = car.Brand + " " + car.Model + ", " + car.Year + " г.\nVIN: " + car.VIN;
                PriceText.Text = shownPrice.ToString("N2") + " ₽";
                NameBox.Text = Core.CurrentUser.FullName;
                PhoneBox.Text = Core.CurrentUser.Phone;
                loaded = true;
            }
            catch (Exception)
            {
                BuyButton.IsEnabled = false;
                MessageBox.Show("Не удалось загрузить автомобиль. Проверьте подключение и откройте заявку заново.", "Покупка");
            }
        }

        private void BuyButton_Click(object sender, RoutedEventArgs e)
        {
            if (!Core.IsCustomer() || !loaded || submitted) return;
            string name = NameBox.Text.Trim();
            string phone = PhoneBox.Text.Trim();
            string email = EmailBox.Text.Trim();
            var errors = new StringBuilder();
            if (name.Length == 0 || name.Length > 150) errors.AppendLine("Укажите ФИО, до 150 символов.");
            if (phone.Length > 20 || !Regex.IsMatch(phone, @"^\+?[0-9() -]+$") || phone.Count(char.IsDigit) < 10 || phone.Count(char.IsDigit) > 15)
                errors.AppendLine("Укажите телефон: от 10 до 15 цифр. Допустимы + в начале, пробелы, скобки и дефисы.");
            if (email.Length > 0 && (email.Length > 100 || !Regex.IsMatch(email, @"^[^\s@]+@[^\s@]+\.[^\s@]+$")))
                errors.AppendLine("Укажите корректный email или оставьте поле пустым.");
            if (errors.Length > 0) { MessageBox.Show(errors.ToString(), "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning); return; }
            if (MessageBox.Show("Зарезервировать автомобиль за " + shownPrice.ToString("N2") + " ₽?\nМенеджер получит указанные контактные данные для оформления покупки.", "Подтверждение заявки", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes) return;
            BuyButton.IsEnabled = false;
            try
            {
                int number;
                string managerName;
                using (var db = new DB_Zhurikhin_AutoDealerManagementEntities())
                using (var transaction = db.Database.BeginTransaction(System.Data.IsolationLevel.Serializable))
                {
                    int userId = Core.CurrentUser.EmployeeID;
                    if (!db.Employees.Any(x => x.EmployeeID == userId && x.IsActive && x.Roles.RoleName == "Пользователь"))
                        throw new InvalidOperationException("Учётная запись недоступна. Войдите заново.");
                    var car = db.Cars.SingleOrDefault(x => x.VIN == vin);
                    if (car == null || car.Status != "На складе")
                        throw new InvalidOperationException("Автомобиль уже недоступен. Вернитесь в каталог и обновите список.");
                    if (car.Price != shownPrice)
                        throw new InvalidOperationException("Цена автомобиля изменилась. Откройте заявку заново и проверьте новую цену.");
                    var manager = db.Employees.Where(x => x.IsActive && x.Roles.RoleName == "Менеджер по продажам").OrderBy(x => x.EmployeeID).FirstOrDefault();
                    if (manager == null)
                        throw new InvalidOperationException("Сейчас нет активного менеджера по продажам. Обратитесь в автодилерский центр.");
                    var client = new Clients { FullName = name, Phone = phone, Email = email.Length == 0 ? null : email };
                    db.Clients.Add(client);
                    db.SaveChanges();
                    var deal = new Deals { VIN = vin, ClientID = client.ClientID, EmployeeID = manager.EmployeeID, DealDate = DateTime.Now, FinalPrice = car.Price, ContractStatus = "Зарезервирован" };
                    db.Deals.Add(deal);
                    db.SaveChanges();
                    transaction.Commit();
                    number = deal.DealID;
                    managerName = manager.FullName;
                }
                submitted = true;
                FormPanel.IsEnabled = false;
                MessageBox.Show("Заявка №" + number + " принята. Автомобиль зарезервирован.\nОтветственный менеджер: " + managerName + ".\nОжидайте связи по указанному телефону.", "Покупка", MessageBoxButton.OK, MessageBoxImage.Information);
                ReturnToCatalog();
            }
            catch (InvalidOperationException ex) { MessageBox.Show(ex.Message, "Покупка", MessageBoxButton.OK, MessageBoxImage.Warning); }
            catch (Exception) { MessageBox.Show("Не удалось оформить заявку. Проверьте подключение и обновите каталог: автомобиль мог быть зарезервирован другим покупателем.", "Покупка", MessageBoxButton.OK, MessageBoxImage.Warning); }
            finally { BuyButton.IsEnabled = !submitted; }
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e) { ReturnToCatalog(); }

        private void ReturnToCatalog()
        {
            if (NavigationService.CanGoBack) NavigationService.GoBack();
            else NavigationService.Navigate(new CarsPage());
        }
    }
}
