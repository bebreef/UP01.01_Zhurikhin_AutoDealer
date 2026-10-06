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

namespace WPF_Zhurikhin_AutoDealer
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            MainFrame.Navigate(new Pages.LoginPage());
        }

        private bool isDarkTheme = false;

        private void ChangeTheme_Click(object sender, RoutedEventArgs e)
        {
            isDarkTheme = !isDarkTheme;

            string theme = isDarkTheme ? "DarkTheme.xaml" : "LightTheme.xaml";

            var dictionary = new ResourceDictionary
            {
                Source = new Uri($"Themes/{theme}", UriKind.Relative)
            };

            Application.Current.Resources.MergedDictionaries[0] = dictionary;
        }


        private void BackButton_Click(object sender, RoutedEventArgs e)
        {
            if (MainFrame.CanGoBack)
            {
                MainFrame.GoBack();
            }
        }

        private void MainFrame_Navigated(object sender, NavigationEventArgs e)
        {
            if (MainFrame.Content is Pages.LoginPage || MainFrame.Content is Pages.RegPage)
            {
                BackButton.Visibility = Visibility.Hidden;
            }
            else
            {
                BackButton.Visibility = Visibility.Visible;
            }
        }
    }
}
