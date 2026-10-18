using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    public partial class ClientsPage : Page
    {
        private List<Clients> clients = new List<Clients>();

        public ClientsPage()
        {
            InitializeComponent();
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            if (Core.IsCustomer()) { IsEnabled = false; return; }
            AddButton.Visibility = Core.CanEditData() ? Visibility.Visible : Visibility.Collapsed;
            EditButton.Visibility = AddButton.Visibility;
            DeleteButton.Visibility = AddButton.Visibility;
            LoadClients();
        }

        private void LoadClients()
        {
            if (Core.CurrentUser == null || Core.IsCustomer())
                return;
            try
            {
                clients = Core.Context.Clients.AsNoTracking().ToList();
                UpdateClients();
            }
            catch (Exception)
            {
                clients.Clear();
                ClientsGrid.ItemsSource = null;
                CountText.Text = "Не удалось загрузить клиентов. Нажмите «Обновить».";
            }
        }

        private void UpdateClients()
        {
            if (!IsLoaded)
                return;
            string search = SearchBox.Text.Trim();
            IEnumerable<Clients> result = clients;
            if (search.Length > 0)
                result = result.Where(x => (x.FullName + " " + x.Phone + " " + x.Passport + " " + x.Email).IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0);
            if (ContactBox.SelectedIndex == 1)
                result = result.Where(x => !string.IsNullOrWhiteSpace(x.Email));
            else if (ContactBox.SelectedIndex == 2)
                result = result.Where(x => string.IsNullOrWhiteSpace(x.Email));
            switch (SortBox.SelectedIndex)
            {
                case 1: result = result.OrderByDescending(x => x.FullName); break;
                case 2: result = result.OrderByDescending(x => x.ClientID); break;
                default: result = result.OrderBy(x => x.FullName); break;
            }
            var shown = result.ToList();
            ClientsGrid.ItemsSource = shown;
            CountText.Text = shown.Count == 0 ? "Клиенты не найдены. Измените условия поиска." : "Показано: " + shown.Count + " из " + clients.Count;
        }

        private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            UpdateClients();
        }

        private void Filter_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            UpdateClients();
        }

        private void ResetButton_Click(object sender, RoutedEventArgs e)
        {
            SearchBox.Clear();
            ContactBox.SelectedIndex = 0;
            SortBox.SelectedIndex = 0;
            UpdateClients();
        }

        private void RefreshButton_Click(object sender, RoutedEventArgs e)
        {
            LoadClients();
        }

        private void AddButton_Click(object sender, RoutedEventArgs e)
        {
            if (Core.CanEditData())
                NavigationService.Navigate(new ClientEditPage(null));
        }

        private void EditButton_Click(object sender, RoutedEventArgs e)
        {
            if (!Core.CanEditData())
                return;
            var client = ClientsGrid.SelectedItem as Clients;
            if (client == null)
            {
                MessageBox.Show("Выберите клиента.", "Клиенты", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            NavigationService.Navigate(new ClientEditPage(client.ClientID));
        }

        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            if (!Core.CanEditData())
                return;
            var selected = ClientsGrid.SelectedItem as Clients;
            if (selected == null)
            {
                MessageBox.Show("Выберите клиента.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            if (MessageBox.Show("Удалить клиента «" + selected.FullName + "»?", "Удаление клиента", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                return;
            Clients client = null;
            try
            {
                if (Core.Context.Deals.Any(x => x.ClientID == selected.ClientID) || Core.Context.ServiceOrders.Any(x => x.ClientID == selected.ClientID))
                {
                    MessageBox.Show("У клиента есть сделки или сервисные заказы. Удаление запрещено, чтобы сохранить связанные документы.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                client = Core.Context.Clients.SingleOrDefault(x => x.ClientID == selected.ClientID);
                if (client != null)
                {
                    Core.Context.Clients.Remove(client);
                    Core.Context.SaveChanges();
                    MessageBox.Show("Клиент удалён.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                    MessageBox.Show("Клиент уже удалён. Список будет обновлён.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Information);
                LoadClients();
            }
            catch (Exception)
            {
                if (client != null)
                    Core.Context.Entry(client).State = EntityState.Detached;
                MessageBox.Show("Не удалось удалить клиента. Проверьте подключение и связанные документы.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }
    }
}
