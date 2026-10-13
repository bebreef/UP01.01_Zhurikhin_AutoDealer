using System;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    public partial class ChangePasswordPage : Page
    {
        public ChangePasswordPage()
        {
            InitializeComponent();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            string login = LoginTB.Text.Trim();

            if (string.IsNullOrWhiteSpace(login) || string.IsNullOrWhiteSpace(OldPasswordTB.Password))
            {
                ShowMessage("Введите логин и текущий пароль.");
                return;
            }

            string error = PasswordHelper.ValidatePassword(PasswordTB.Password, ConfirmPasswordTB.Password);

            if (error != null)
            {
                ShowMessage(error);
                PasswordTB.Clear();
                ConfirmPasswordTB.Clear();
                PasswordTB.Focus();
                return;
            }

            Employees employee = null;
            string oldHash = null;
            SaveButton.IsEnabled = false;

            try
            {
                employee = Core.Context.Employees.FirstOrDefault(x => x.Login == login);

                if (employee == null || !PasswordHelper.VerifyPassword(OldPasswordTB.Password, employee.PasswordHash))
                {
                    ShowMessage("Неверный логин или текущий пароль.");
                    ClearPasswords();
                    OldPasswordTB.Focus();
                    return;
                }

                if (OldPasswordTB.Password == PasswordTB.Password)
                {
                    ShowMessage("Новый пароль должен отличаться от текущего.");
                    PasswordTB.Clear();
                    ConfirmPasswordTB.Clear();
                    return;
                }

                oldHash = employee.PasswordHash;
                employee.PasswordHash = PasswordHelper.HashPassword(PasswordTB.Password);
                Core.Context.SaveChanges();
            }
            catch (Exception)
            {
                if (employee != null && oldHash != null)
                {
                    employee.PasswordHash = oldHash;
                    Core.Context.Entry(employee).Property(x => x.PasswordHash).IsModified = false;
                }

                ShowMessage("Не удалось изменить пароль. Проверьте подключение к базе данных и попробуйте снова.");
                return;
            }
            finally
            {
                SaveButton.IsEnabled = true;
            }

            ClearPasswords();
            ShowMessage("Пароль успешно изменен.", MessageBoxImage.Information);
            ReturnToLogin();
        }

        private void ClearPasswords()
        {
            OldPasswordTB.Clear();
            PasswordTB.Clear();
            ConfirmPasswordTB.Clear();
        }

        private void ShowMessage(string text, MessageBoxImage icon = MessageBoxImage.Warning)
        {
            MessageBox.Show(text, "Смена пароля", MessageBoxButton.OK, icon);
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

