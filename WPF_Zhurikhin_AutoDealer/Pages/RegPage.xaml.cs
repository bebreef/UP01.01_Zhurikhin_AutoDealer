using System;
using System.Data.Entity;
using System.Linq;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    public partial class RegPage : Page
    {
        public RegPage()
        {
            InitializeComponent();
            LoadRoles();
        }

        private void LoadRoles()
        {
            try
            {
                var roles = Core.Context.Roles.Where(x => x.RoleName == "Пользователь").ToList();
                RoleCB.ItemsSource = roles;
                RoleCB.SelectedItem = roles.FirstOrDefault(x => x.RoleName == "Пользователь")
                    ?? roles.FirstOrDefault(x => x.RoleName != "Администратор");

                if (roles.Count == 0)
                    ShowMessage("В таблице Roles нет ролей. Сначала заполните справочник.");
            }
            catch (Exception)
            {
                SaveButton.IsEnabled = false;
                ShowMessage("Не удалось загрузить роли. Проверьте подключение к базе данных.");
            }
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            string fullName = FullNameTB.Text.Trim();
            string position = PositionTB.Text.Trim();
            string phone = PhoneTB.Text.Trim();
            string login = LoginTB.Text.Trim();
            var role = RoleCB.SelectedItem as Roles;

            if (string.IsNullOrWhiteSpace(fullName) || string.IsNullOrWhiteSpace(position) || string.IsNullOrWhiteSpace(login) || role == null)
            {
                ShowMessage("Заполните ФИО, должность, логин и выберите роль.");
                return;
            }

            if (!Regex.IsMatch(fullName, @"^[\p{L}]+(?:[ '\-][\p{L}]+)*$"))
            {
                ShowMessage("ФИО может содержать буквы, пробелы, дефисы и апострофы.");
                return;
            }

            if (!Regex.IsMatch(login, @"^[A-Za-z0-9_.-]+$"))
            {
                ShowMessage("Логин может содержать латинские буквы, цифры, точку, дефис и подчеркивание.");
                return;
            }

            if (phone.Length > 0 && (!Regex.IsMatch(phone, @"^\+?[0-9() \-]+$") || phone.Count(char.IsDigit) < 10 || phone.Count(char.IsDigit) > 15))
            {
                ShowMessage("Телефон должен содержать от 10 до 15 цифр. Допустимы + в начале, пробелы, скобки и дефисы.");
                return;
            }

            string error = PasswordHelper.ValidatePassword(PasswordTB.Password, ConfirmPasswordTB.Password);

            if (error != null)
            {
                ShowMessage(error);
                ClearPasswords();
                return;
            }

            Employees employee = null;
            SaveButton.IsEnabled = false;

            try
            {
                if (Core.Context.Employees.Any(x => x.Login == login))
                {
                    ShowMessage("Этот логин уже занят.");
                    LoginTB.Focus();
                    return;
                }

                employee = new Employees
                {
                    FullName = fullName,
                    Position = position,
                    Phone = phone.Length == 0 ? null : phone,
                    Login = login,
                    PasswordHash = PasswordHelper.HashPassword(PasswordTB.Password),
                    RoleID = role.RoleID,
                    IsActive = true
                };

                Core.Context.Employees.Add(employee);
                Core.Context.SaveChanges();
            }
            catch (Exception)
            {
                if (employee != null)
                    Core.Context.Entry(employee).State = EntityState.Detached;

                ShowMessage("Не удалось сохранить пользователя. Проверьте подключение к БД и уникальность логина.");
                return;
            }
            finally
            {
                SaveButton.IsEnabled = true;
            }

            ClearPasswords();
            ShowMessage("Регистрация завершена. Теперь войдите с новым логином и паролем.", MessageBoxImage.Information);
            ReturnToLogin();
        }

        private void ClearPasswords()
        {
            PasswordTB.Clear();
            ConfirmPasswordTB.Clear();
            PasswordTB.Focus();
        }

        private void ShowMessage(string text, MessageBoxImage icon = MessageBoxImage.Warning)
        {
            MessageBox.Show(text, "Регистрация", MessageBoxButton.OK, icon);
        }

        private void BackButton_Click(object sender, RoutedEventArgs e)
        {
            ClearPasswords();
            ReturnToLogin();
        }

        private void ReturnToLogin()
        {
            if (NavigationService.CanGoBack)
                NavigationService.GoBack();
            else
                NavigationService.Navigate(new LoginPage());
        }
    }
}
