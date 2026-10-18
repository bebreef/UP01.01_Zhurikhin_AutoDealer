using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    public partial class DealsPage : Page
    {
        private List<Deals> deals = new List<Deals>();

        public DealsPage()
        {
            InitializeComponent();
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            if (Core.IsCustomer()) { IsEnabled = false; return; }
            AddButton.Visibility = Core.CanEditData() ? Visibility.Visible : Visibility.Collapsed;
            DeleteButton.Visibility = AddButton.Visibility;
            LoadDeals();
        }

        private void LoadDeals()
        {
            if (Core.CurrentUser == null || Core.IsCustomer())
                return;
            try
            {
                deals = Core.Context.Deals.Include(x => x.Cars).Include(x => x.Clients).Include(x => x.Employees).AsNoTracking().ToList();
                UpdateDeals();
            }
            catch (Exception)
            {
                deals.Clear();
                DealsGrid.ItemsSource = null;
                CountText.Text = "Не удалось загрузить сделки. Нажмите «Обновить».";
            }
        }

        private void UpdateDeals()
        {
            if (!IsLoaded)
                return;
            string search = SearchBox.Text.Trim();
            IEnumerable<Deals> result = deals;
            if (search.Length > 0)
                result = result.Where(x => (x.DealID + " " + x.VIN + " " + x.Cars.Brand + " " + x.Cars.Model + " " + x.Clients.FullName + " " + x.Employees.FullName).IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0);
            if (StatusBox.SelectedIndex > 0)
                result = result.Where(x => x.ContractStatus == (string)((ComboBoxItem)StatusBox.SelectedItem).Content);
            switch (SortBox.SelectedIndex)
            {
                case 1: result = result.OrderBy(x => x.DealDate).ThenBy(x => x.DealID); break;
                case 2: result = result.OrderBy(x => x.FinalPrice).ThenBy(x => x.DealID); break;
                case 3: result = result.OrderByDescending(x => x.FinalPrice).ThenBy(x => x.DealID); break;
                default: result = result.OrderByDescending(x => x.DealDate).ThenByDescending(x => x.DealID); break;
            }
            var shown = result.ToList();
            DealsGrid.ItemsSource = shown;
            CountText.Text = shown.Count == 0 ? "Сделки не найдены. Измените условия поиска." : "Показано: " + shown.Count + " из " + deals.Count;
        }

        private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            UpdateDeals();
        }

        private void Filter_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            UpdateDeals();
        }

        private void ResetButton_Click(object sender, RoutedEventArgs e)
        {
            SearchBox.Clear();
            StatusBox.SelectedIndex = 0;
            SortBox.SelectedIndex = 0;
            UpdateDeals();
        }

        private void RefreshButton_Click(object sender, RoutedEventArgs e)
        {
            LoadDeals();
        }

        private void AddButton_Click(object sender, RoutedEventArgs e)
        {
            if (Core.CanEditData())
                NavigationService.Navigate(new DealEditPage(null));
        }

        private void EditButton_Click(object sender, RoutedEventArgs e)
        {
            var deal = DealsGrid.SelectedItem as Deals;
            if (deal == null)
            {
                MessageBox.Show("Выберите сделку.", "Сделки", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            NavigationService.Navigate(new DealEditPage(deal.DealID));
        }

        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            if (!Core.CanEditData())
                return;
            var selected = DealsGrid.SelectedItem as Deals;
            if (selected == null)
            {
                MessageBox.Show("Выберите сделку.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            if (selected.ContractStatus != "Черновик")
            {
                MessageBox.Show("Удалять можно только черновики. Резерв можно отменить через форму сделки.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            if (MessageBox.Show("Удалить черновик сделки №" + selected.DealID + "?", "Удаление сделки", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                return;
            Deals deal = null;
            try
            {
                deal = Core.Context.Deals.SingleOrDefault(x => x.DealID == selected.DealID);
                if (deal != null)
                {
                    Core.Context.Entry(deal).Reload();
                    if (deal.ContractStatus != "Черновик")
                    {
                        MessageBox.Show("Статус сделки уже изменился. Обновите список.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Warning);
                        return;
                    }
                    Core.Context.Deals.Remove(deal);
                    Core.Context.SaveChanges();
                    MessageBox.Show("Черновик удалён.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                LoadDeals();
            }
            catch (Exception)
            {
                if (deal != null)
                    Core.Context.Entry(deal).State = EntityState.Detached;
                MessageBox.Show("Не удалось удалить черновик. Проверьте подключение и обновите список.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }
    }
}
