using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    /// <summary>
    /// Логика взаимодействия для RegPage.xaml
    /// </summary>
    public partial class LoginPage : Page
    {
        private int errcount = 0;
        private readonly Random random = new Random();

        public LoginPage()
        {
            InitializeComponent();
        }

        private void LoginButton_Click(object sender, RoutedEventArgs e)
        {
            string login = LoginTB.Text.Trim();
            string password = PasswordTB.Password;

            if (string.IsNullOrWhiteSpace(login) || string.IsNullOrWhiteSpace(password))
            {
                MessageBox.Show("Введите логин и пароль.", "Авторизация", MessageBoxButton.OK, MessageBoxImage.Warning);
                ClearLoginFields();
                return;
            }

            var employee = Core.Context.Employees.FirstOrDefault(x => x.Login == login);

            if (employee == null || !PasswordHelper.VerifyPassword(password, employee.PasswordHash))
            {
                errcount++;
                ClearLoginFields();

                if (errcount % 3 == 0)
                {
                    ShowCaptcha();
                }

                MessageBox.Show("Неверный логин или пароль.", "Авторизация", MessageBoxButton.OK, MessageBoxImage.Warning);

                if (CaptchaGrid.Visibility == Visibility.Visible)
                {
                    CaptchaTB.Focus();
                }
                else
                {
                    LoginTB.Focus();
                }

                return;
            }

            errcount = 0;
            Core.CurrentUser = employee;

            MessageBox.Show($"Добро пожаловать, {employee.FullName}!", "Авторизация", MessageBoxButton.OK, MessageBoxImage.Information);
            NavigationService.Navigate(new MainPage());
        }

        private void ClearLoginFields()
        {
            LoginTB.Clear();
            PasswordTB.Clear();
        }

        private void ShowCaptcha()
        {
            CaptchaTB.Clear();
            CaptchaChange();
            CaptchaGrid.Visibility = Visibility.Visible;
            LoginButton.IsEnabled = false;
            LoginTB.IsEnabled = false;
            PasswordTB.IsEnabled = false;
        }

        private void CaptchaChange()
        {
            string characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            char[] captcha = new char[6];

            for (int i = 0; i < captcha.Length; i++)
            {
                captcha[i] = characters[random.Next(characters.Length)];
            }

            CaptchaText.Text = new string(captcha);
        }

        private void CaptchaConfirm_Click(object sender, RoutedEventArgs e)
        {
            if (CaptchaTB.Text.Trim() != CaptchaText.Text)
            {
                CaptchaTB.Clear();
                CaptchaChange();

                MessageBox.Show("Неверная капча. Попробуйте ещё раз.", "Авторизация", MessageBoxButton.OK, MessageBoxImage.Warning);
                CaptchaTB.Focus();
                return;
            }

            CaptchaTB.Clear();
            CaptchaGrid.Visibility = Visibility.Collapsed;
            LoginButton.IsEnabled = true;
            LoginTB.IsEnabled = true;
            PasswordTB.IsEnabled = true;
            LoginTB.Focus();
        }

        private void ChangePassword_Click(object sender, RoutedEventArgs e)
        {
            NavigationService.Navigate(new ChangePasswordPage());
        }

        private void RegButton_Click(object sender, RoutedEventArgs e)
        {
            NavigationService.Navigate(new RegPage());
        }
    }
}