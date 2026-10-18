using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    public partial class CarsPage : Page
    {
        private List<Cars> cars = new List<Cars>();
        private bool loading;

        public CarsPage()
        {
            InitializeComponent();
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            HeadingText.Text = Core.IsCustomer() ? "Каталог автомобилей" : "Автомобили";
            BuyButton.Visibility = Core.IsCustomer() ? Visibility.Visible : Visibility.Collapsed;
            CarsGrid.ToolTip = Core.IsCustomer() ? "Выберите автомобиль на складе и нажмите «Купить»" : "Выберите автомобиль для редактирования или удаления";
            bool canEdit = Core.CanEditData();
            AddButton.Visibility = canEdit ? Visibility.Visible : Visibility.Collapsed;
            EditButton.Visibility = AddButton.Visibility;
            DeleteButton.Visibility = AddButton.Visibility;
            LoadCars();
        }

        private void LoadCars()
        {
            if (Core.CurrentUser == null)
                return;

            loading = true;
            try
            {
                string selectedBrand = BrandBox.SelectedItem as string;
                string selectedStatus = StatusBox.SelectedItem as string;
                cars = Core.Context.Cars.AsNoTracking().ToList();
                var brands = cars.Select(x => x.Brand).Distinct().OrderBy(x => x).ToList();
                brands.Insert(0, "Все марки");
                BrandBox.ItemsSource = brands;
                BrandBox.SelectedItem = brands.Contains(selectedBrand) ? selectedBrand : "Все марки";
                StatusBox.ItemsSource = new[] { "Все статусы", "На складе", "В пути", "Зарезервирован", "Продан", "На диагностике" };
                StatusBox.SelectedItem = selectedStatus ?? "Все статусы";
                if (SortBox.SelectedIndex < 0)
                    SortBox.SelectedIndex = 0;
            }
            catch (Exception)
            {
                cars.Clear();
                CarsGrid.ItemsSource = null;
                CountText.Text = "Не удалось загрузить автомобили. Нажмите «Обновить» для повторной попытки.";
                return;
            }
            finally
            {
                loading = false;
            }
            UpdateCars();
        }

        private void UpdateCars()
        {
            if (!IsLoaded || loading)
                return;

            string search = SearchBox.Text.Trim();
            IEnumerable<Cars> result = cars;
            if (search.Length > 0)
                result = result.Where(x => x.VIN.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0 || x.Brand.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0 || x.Model.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0);
            if (BrandBox.SelectedIndex > 0)
                result = result.Where(x => x.Brand == (string)BrandBox.SelectedItem);
            if (StatusBox.SelectedIndex > 0)
                result = result.Where(x => x.Status == (string)StatusBox.SelectedItem);

            switch (SortBox.SelectedIndex)
            {
                case 1: result = result.OrderByDescending(x => x.Brand).ThenByDescending(x => x.Model); break;
                case 2: result = result.OrderBy(x => x.Price).ThenBy(x => x.VIN); break;
                case 3: result = result.OrderByDescending(x => x.Price).ThenBy(x => x.VIN); break;
                case 4: result = result.OrderByDescending(x => x.Year).ThenBy(x => x.Brand); break;
                case 5: result = result.OrderBy(x => x.Year).ThenBy(x => x.Brand); break;
                default: result = result.OrderBy(x => x.Brand).ThenBy(x => x.Model); break;
            }

            var shown = result.ToList();
            CarsGrid.ItemsSource = shown;
            CountText.Text = shown.Count == 0 ? "Автомобили не найдены. Измените условия поиска." : "Показано: " + shown.Count + " из " + cars.Count;
        }

        private void SearchBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            UpdateCars();
        }

        private void Filter_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            UpdateCars();
        }

        private void ResetButton_Click(object sender, RoutedEventArgs e)
        {
            loading = true;
            SearchBox.Clear();
            BrandBox.SelectedIndex = 0;
            StatusBox.SelectedIndex = 0;
            SortBox.SelectedIndex = 0;
            loading = false;
            UpdateCars();
        }

        private void RefreshButton_Click(object sender, RoutedEventArgs e)
        {
            LoadCars();
        }

        private void BuyButton_Click(object sender, RoutedEventArgs e)
        {
            if (!Core.IsCustomer()) return;
            var car = CarsGrid.SelectedItem as Cars;
            if (car == null)
            {
                MessageBox.Show("Выберите автомобиль.", "Покупка", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            if (car.Status != "На складе")
            {
                MessageBox.Show("Для покупки доступны автомобили со статусом «На складе».", "Покупка", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            NavigationService.Navigate(new BuyCarPage(car.VIN));
        }

        private void AddButton_Click(object sender, RoutedEventArgs e)
        {
            if (Core.CanEditData())
                NavigationService.Navigate(new CarEditPage(null));
        }

        private void EditButton_Click(object sender, RoutedEventArgs e)
        {
            if (!Core.CanEditData())
                return;
            var car = CarsGrid.SelectedItem as Cars;
            if (car == null)
            {
                MessageBox.Show("Выберите автомобиль.", "Автомобили", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            NavigationService.Navigate(new CarEditPage(car.VIN));
        }

        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            if (!Core.CanEditData())
                return;
            var selected = CarsGrid.SelectedItem as Cars;
            if (selected == null)
            {
                MessageBox.Show("Выберите автомобиль.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            if (MessageBox.Show("Удалить " + selected.Brand + " " + selected.Model + " (" + selected.VIN + ")?", "Удаление автомобиля", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                return;

            Cars car = null;
            try
            {
                if (Core.Context.Deals.Any(x => x.VIN == selected.VIN) || Core.Context.ServiceOrders.Any(x => x.VIN == selected.VIN))
                {
                    MessageBox.Show("У автомобиля есть сделки или сервисные заказы. Удаление запрещено, чтобы сохранить связанные документы.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                car = Core.Context.Cars.SingleOrDefault(x => x.VIN == selected.VIN);
                if (car == null)
                {
                    MessageBox.Show("Автомобиль уже удалён. Список будет обновлён.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                {
                    Core.Context.Cars.Remove(car);
                    Core.Context.SaveChanges();
                    MessageBox.Show("Автомобиль удалён.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                LoadCars();
            }
            catch (Exception)
            {
                if (car != null)
                    Core.Context.Entry(car).State = EntityState.Detached;
                MessageBox.Show("Не удалось удалить автомобиль. Проверьте подключение и связанные документы, затем обновите список.", "Удаление", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }
    }
}
