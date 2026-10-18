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
            if (Core.CurrentUser != null)
            {
                LoginTB.Text = Core.CurrentUser.Login;
                LoginTB.IsReadOnly = true;
                BackButton.Content = "Назад";
            }
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            string login = Core.CurrentUser == null ? LoginTB.Text.Trim() : Core.CurrentUser.Login;

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

            if (MessageBox.Show("Сохранить новый пароль?", "Смена пароля", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                return;
            SaveButton.IsEnabled = false;

            try
            {
                using (var db = new DB_Zhurikhin_AutoDealerManagementEntities())
                using (var transaction = db.Database.BeginTransaction(System.Data.IsolationLevel.Serializable))
                {
                    var employee = db.Employees.FirstOrDefault(x => x.Login == login && x.IsActive);
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

                    employee.PasswordHash = PasswordHelper.HashPassword(PasswordTB.Password);
                    db.SaveChanges();
                    transaction.Commit();
                }
            }
            catch (Exception)
            {
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
                NavigationService.Navigate(Core.CurrentUser == null ? (Page)new LoginPage() : Core.IsCustomer() ? (Page)new CarsPage() : new MainPage());
        }
    }
}

