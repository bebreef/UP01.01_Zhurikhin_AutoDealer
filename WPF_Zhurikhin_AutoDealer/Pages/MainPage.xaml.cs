using System;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    public partial class MainPage : Page
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            if (Core.CurrentUser == null)
                return;

            WelcomeText.Text = "Добро пожаловать, " + Core.CurrentUser.FullName + "!";
            LoadSummary();
        }

        private void RefreshButton_Click(object sender, RoutedEventArgs e)
        {
            LoadSummary();
        }

        private void LoadSummary()
        {
            if (Core.CurrentUser == null)
                return;

            try
            {
                RoleText.Text = "Роль: " + (Core.CurrentUser.Roles == null ? "не назначена" : Core.CurrentUser.Roles.RoleName);
                int cars = Core.Context.Cars.Count();
                int clients = Core.Context.Clients.Count();
                int deals = Core.Context.Deals.Count();
                CarsCountText.Text = cars.ToString();
                ClientsCountText.Text = clients.ToString();
                DealsCountText.Text = deals.ToString();
                StatusText.Text = "Обновлено: " + DateTime.Now.ToString("dd.MM.yyyy HH:mm");
            }
            catch (Exception)
            {
                CarsCountText.Text = "—";
                ClientsCountText.Text = "—";
                DealsCountText.Text = "—";
                StatusText.Text = "Не удалось загрузить сведения. Проверьте подключение к базе данных и нажмите «Обновить сведения».";
            }
        }
    }
}
