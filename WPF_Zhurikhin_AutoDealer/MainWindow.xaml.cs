using System;
using System.ComponentModel;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Navigation;
using System.Windows.Threading;
using WPF_Zhurikhin_AutoDealer.Pages;

namespace WPF_Zhurikhin_AutoDealer
{
    public partial class MainWindow : Window
    {
        private bool isDarkTheme;
        private bool menuExpanded;
        private bool wasSignedIn;
        private readonly string themeFile = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "AutoDealer", "theme.txt");

        public MainWindow()
        {
            InitializeComponent();
            LoadTheme();
            var timer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(1) };
            timer.Tick += (sender, e) => DateTimeText.Text = DateTime.Now.ToString("dd.MM.yyyy HH:mm:ss");
            DateTimeText.Text = DateTime.Now.ToString("dd.MM.yyyy HH:mm:ss");
            timer.Start();
            Closed += (sender, e) => timer.Stop();
            MainFrame.Navigate(new LoginPage());
        }

        private bool IsAdministrator()
        {
            return Core.CurrentUser != null && Core.CurrentUser.Roles != null && Core.CurrentUser.Roles.RoleName == "Администратор";
        }

        private void LoadTheme()
        {
            try
            {
                isDarkTheme = File.Exists(themeFile) && File.ReadAllText(themeFile) == "Dark";
            }
            catch (Exception)
            {
                isDarkTheme = false;
            }

            ApplyTheme();
        }

        private bool CanViewReports()
        {
            return IsAdministrator() || Core.CurrentUser?.Roles?.RoleName == "Руководитель";
        }

        private void ApplyTheme()
        {
            string theme = isDarkTheme ? "DarkTheme.xaml" : "LightTheme.xaml";
            Application.Current.Resources.MergedDictionaries[0] = new ResourceDictionary
            {
                Source = new Uri("Themes/" + theme, UriKind.Relative)
            };
        }

        private void ChangeTheme_Click(object sender, RoutedEventArgs e)
        {
            isDarkTheme = !isDarkTheme;
            ApplyTheme();

            try
            {
                Directory.CreateDirectory(Path.GetDirectoryName(themeFile));
                File.WriteAllText(themeFile, isDarkTheme ? "Dark" : "Light");
            }
            catch (Exception)
            {
                MessageBox.Show("Тема изменена, но сохранить её для следующего запуска не удалось.", "Оформление", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        private void LogoutButton_Click(object sender, RoutedEventArgs e)
        {
            Logout();
        }

        private void MenuArea_MouseEnter(object sender, MouseEventArgs e)
        {
            SetMenuOpen(true);
        }

        private void MenuArea_MouseLeave(object sender, MouseEventArgs e)
        {
            SetMenuOpen(false);
        }

        private void SetMenuOpen(bool open)
        {
            if (Core.CurrentUser == null || menuExpanded == open)
                return;

            menuExpanded = open;
            Sidebar.IsHitTestVisible = open;
            Sidebar.IsEnabled = open;
            var duration = TimeSpan.FromMilliseconds(220);
            var easing = new QuadraticEase { EasingMode = EasingMode.EaseInOut };
            MenuTransform.BeginAnimation(TranslateTransform.XProperty, new DoubleAnimation(open ? 0 : -220, duration) { EasingFunction = easing });
            MenuArea.BeginAnimation(WidthProperty, new DoubleAnimation(open ? 220 : 14, duration) { EasingFunction = easing });
        }

        private void NavigationButton_Click(object sender, RoutedEventArgs e)
        {
            if (Core.CurrentUser == null)
                return;

            string section = (string)((Button)sender).Tag;

            if ((section == "employees" && !IsAdministrator()) || (section == "reports" && !CanViewReports()))
            {
                MessageBox.Show("Для вашей роли этот раздел недоступен.", "Доступ", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            Page page;

            switch (section)
            {
                case "home": page = new MainPage(); break;
                case "cars": page = new CarsPage(); break;
                case "clients": page = new ClientsPage(); break;
                case "deals": page = new DealsPage(); break;
                case "employees": page = new EmployeesPage(); break;
                case "reports": page = new ReportsPage(); break;
                case "password": page = new ChangePasswordPage(); break;
                default: return;
            }

            MainFrame.Navigate(page);
        }

        private void Logout()
        {
            if (MessageBox.Show("Вы действительно хотите выйти из учетной записи?", "Выход", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                return;

            Core.CurrentUser = null;
            menuExpanded = false;
            MenuArea.BeginAnimation(WidthProperty, null);
            MenuTransform.BeginAnimation(TranslateTransform.XProperty, null);
            MenuArea.Width = 14;
            MenuTransform.X = -220;
            MainFrame.Navigate(new LoginPage());
        }

        private void BackButton_Click(object sender, RoutedEventArgs e)
        {
            if (MainFrame.CanGoBack)
                MainFrame.GoBack();
        }

        private void MainFrame_Navigating(object sender, NavigatingCancelEventArgs e)
        {
            bool isPublic = e.Content is LoginPage || e.Content is RegPage || e.Content is ChangePasswordPage;

            if (Core.CurrentUser == null && !isPublic)
            {
                e.Cancel = true;
                return;
            }

            if (Core.CurrentUser != null && (e.Content is LoginPage || e.Content is RegPage))
                e.Cancel = true;

            if ((e.Content is EmployeesPage && !IsAdministrator()) || (e.Content is ReportsPage && !CanViewReports()))
                e.Cancel = true;
        }

        private void MainFrame_Navigated(object sender, NavigationEventArgs e)
        {
            bool signedIn = Core.CurrentUser != null;

            if (signedIn != wasSignedIn)
            {
                while (MainFrame.RemoveBackEntry() != null) { }
                wasSignedIn = signedIn;
            }

            MenuArea.Visibility = signedIn ? Visibility.Visible : Visibility.Collapsed;
            LogoutButton.Visibility = MenuArea.Visibility;
            Sidebar.IsHitTestVisible = menuExpanded;
            Sidebar.IsEnabled = menuExpanded;
            MainFrame.Margin = signedIn ? new Thickness(14, 0, 0, 0) : new Thickness(0);
            EmployeesMenu.Visibility = IsAdministrator() ? Visibility.Visible : Visibility.Collapsed;
            ReportsMenu.Visibility = CanViewReports() ? Visibility.Visible : Visibility.Collapsed;
            BackButton.Visibility = MainFrame.CanGoBack ? Visibility.Visible : Visibility.Collapsed;
            var page = e.Content as Page;
            if (page is CarsPage) page.Title = "Автомобили";
            else if (page is ClientsPage) page.Title = "Клиенты";
            else if (page is DealsPage) page.Title = "Сделки";
            else if (page is EmployeesPage) page.Title = "Сотрудники";
            else if (page is ReportsPage) page.Title = "Отчёты";
        }

        private void Window_Closing(object sender, CancelEventArgs e)
        {
            e.Cancel = MessageBox.Show("Вы действительно хотите закрыть приложение?", "Выход", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes;
        }
    }
}
