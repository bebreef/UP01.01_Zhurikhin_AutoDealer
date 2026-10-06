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
    public partial class RegPage : Page
    {
        static int errcount = 0;
        public RegPage()
        {
            InitializeComponent();
            if (errcount%3 == 0)
            {
                LoginButton.IsEnabled = false;
                ShowCaptcha();
                CaptchaChange();
            }
        }

        private void ShowCaptcha()
        {
            CaptchaGrid.Visibility = Visibility.Visible;
        }
        public void CaptchaChange()
        {
            String allowchar = " ";
            allowchar = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"; allowchar += "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,y,z"; allowchar += "1,2,3,4,5,6,7,8,9,0";
            char[] a = { ',' };
            String[] ar = allowchar.Split(a);
            String pwd = "";
            string temp = "";
            Random r = new Random();
            for (int i = 0; i < 6; i++)
            {
                temp = ar[(r.Next(0, ar.Length))];
                pwd += temp;
            }
            CaptchaText.Text = pwd;
        }


        private void ChangePassword_Click(object sender, RoutedEventArgs e)
        {
            NavigationService.Navigate(new Pages.ChangePasswordPage());
        }

        private void RegButton_Click(object sender, RoutedEventArgs e)
        {
            NavigationService.Navigate(new Pages.RegPage());
        }

        private void LoginButton_Click(object sender, RoutedEventArgs e)
        {
            string login = LoginTB.Text.Trim();
            string password = PasswordTB.Password;
            if (string.IsNullOrWhiteSpace(login) || string.IsNullOrWhiteSpace(password))
            {
                MessageBox.Show("Введите логин и пароль.", "Авторизация", MessageBoxButton.OK , MessageBoxImage.Warning);
                errcount++;
                return;
            }
            var employee = Core.Context.Employees.FirstOrDefault(x=>x.Login == login);
            if (employee == null || !PasswordHelper.VerifyPassword(password, employee.PasswordHash))
            {
                MessageBox.Show("Неверный логин или пароль.", "Авторизация", MessageBoxButton.OK, MessageBoxImage.Warning);
                errcount++;
                return;
            }
            Core.CurrentUser = employee;
            MessageBox.Show($"Добро пожаловать, {employee.FullName}!");
            NavigationService.Navigate(new MainPage());
        }

        private void CaptchaConfirm_Click(object sender, RoutedEventArgs e)
        {
            if (CaptchaTB.Text.Trim() == CaptchaText.Text.Trim())
            {
                CaptchaGrid.Visibility = Visibility.Collapsed;
                LoginButton.IsEnabled = true;
            }
            else
            {
                MessageBox.Show("Неверная капча.", "Авторизация", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
        }
    }
}
