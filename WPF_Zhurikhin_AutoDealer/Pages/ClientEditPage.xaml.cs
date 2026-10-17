using System;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    public partial class ClientEditPage : Page
    {
        private int? clientId;

        public ClientEditPage(int? id)
        {
            InitializeComponent();
            clientId = id;
            Title = id.HasValue ? "Редактирование клиента" : "Добавление клиента";
            HeadingText.Text = Title;
            SaveButton.IsEnabled = Core.CanEditData();
            if (!id.HasValue)
                return;
            try
            {
                var client = Core.Context.Clients.AsNoTracking().SingleOrDefault(x => x.ClientID == id.Value);
                if (client == null)
                {
                    SaveButton.IsEnabled = false;
                    MessageBox.Show("Клиент уже удалён. Вернитесь к списку.", "Клиенты", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                FullNameBox.Text = client.FullName;
                PhoneBox.Text = client.Phone;
                PassportBox.Text = client.Passport;
                EmailBox.Text = client.Email;
            }
            catch (Exception)
            {
                SaveButton.IsEnabled = false;
                MessageBox.Show("Не удалось загрузить клиента. Проверьте подключение и откройте форму заново.", "Клиенты", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (!Core.CanEditData())
                return;
            string fullName = FullNameBox.Text.Trim();
            string phone = PhoneBox.Text.Trim();
            string passport = PassportBox.Text.Trim();
            string email = EmailBox.Text.Trim();
            var errors = new StringBuilder();
            if (fullName.Length == 0 || fullName.Length > 150)
                errors.AppendLine("Введите ФИО (до 150 символов).");
            int digits = phone.Count(c => c >= '0' && c <= '9');
            if (phone.Length > 20 || digits < 10 || digits > 15 || !Regex.IsMatch(phone, @"^\+?[0-9 ()-]+$"))
                errors.AppendLine("Введите телефон: от 10 до 15 цифр, допустимы + в начале, пробелы, скобки и дефисы (до 20 символов).");
            if (passport.Length > 30)
                errors.AppendLine("Паспорт должен содержать не более 30 символов.");
            if (email.Length > 0 && (email.Length > 100 || !Regex.IsMatch(email, @"^[^\s@]+@[^\s@]+\.[^\s@]+$")))
                errors.AppendLine("Введите корректный email, например name@example.com, или оставьте поле пустым.");
            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString(), "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            Clients client = null;
            SaveButton.IsEnabled = false;
            try
            {
                if (!clientId.HasValue)
                {
                    client = new Clients();
                    Core.Context.Clients.Add(client);
                }
                else
                {
                    client = Core.Context.Clients.SingleOrDefault(x => x.ClientID == clientId.Value);
                    if (client == null)
                    {
                        MessageBox.Show("Клиент уже удалён. Вернитесь к списку.", "Сохранение", MessageBoxButton.OK, MessageBoxImage.Warning);
                        return;
                    }
                    Core.Context.Entry(client).Reload();
                }
                client.FullName = fullName;
                client.Phone = phone;
                client.Passport = passport.Length == 0 ? null : passport;
                client.Email = email.Length == 0 ? null : email;
                Core.Context.SaveChanges();
                Core.Context.Entry(client).State = EntityState.Detached;
                MessageBox.Show("Клиент сохранён.", "Сохранение", MessageBoxButton.OK, MessageBoxImage.Information);
                ReturnToList();
            }
            catch (Exception)
            {
                if (client != null)
                    Core.Context.Entry(client).State = EntityState.Detached;
                MessageBox.Show("Не удалось сохранить клиента. Проверьте подключение к базе данных и повторите попытку.", "Сохранение", MessageBoxButton.OK, MessageBoxImage.Warning);
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
                NavigationService.Navigate(new ClientsPage());
        }
    }
}
