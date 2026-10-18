using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;

namespace WPF_Zhurikhin_AutoDealer.Pages
{
    public partial class EmployeesPage : Page
    {
        private List<Employees> employees = new List<Employees>();
        private int? selectedId;
        private bool loading;

        public EmployeesPage()
        {
            InitializeComponent();
        }

        private bool CanManage()
        {
            return Core.CurrentUser != null && Core.CurrentUser.Roles.RoleName == "Администратор";
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            ContentPanel.IsEnabled = CanManage();
            if (CanManage()) LoadEmployees();
        }

        private void LoadEmployees()
        {
            loading = true;
            try
            {
                employees = Core.Context.Employees.Include(x => x.Roles).AsNoTracking().OrderBy(x => x.FullName).ToList();
                var roles = Core.Context.Roles.AsNoTracking().OrderBy(x => x.RoleName).ToList();
                RoleBox.ItemsSource = roles;
                var filter = roles.Select(x => x.RoleName).ToList();
                filter.Insert(0, "Все роли");
                FilterRoleBox.ItemsSource = filter;
                FilterRoleBox.SelectedIndex = 0;
                CloseEditor();
            }
            catch (Exception)
            {
                employees.Clear();
                MessageBox.Show("Не удалось загрузить сотрудников. Проверьте подключение.", "Сотрудники", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
            finally { loading = false; }
            UpdateEmployees();
        }

        private void UpdateEmployees()
        {
            if (!IsLoaded || loading) return;
            string search = SearchBox.Text.Trim();
            IEnumerable<Employees> result = employees;
            if (search.Length > 0)
                result = result.Where(x => (x.FullName + " " + x.Login + " " + x.Position + " " + x.Phone).IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0);
            if (FilterRoleBox.SelectedIndex > 0)
                result = result.Where(x => x.Roles.RoleName == (string)FilterRoleBox.SelectedItem);
            if (StateBox.SelectedIndex == 1) result = result.Where(x => x.IsActive);
            if (StateBox.SelectedIndex == 2) result = result.Where(x => !x.IsActive);
            var shown = result.ToList();
            EmployeesGrid.ItemsSource = shown;
            CountText.Text = "Показано: " + shown.Count + " из " + employees.Count;
        }

        private void SearchBox_TextChanged(object sender, TextChangedEventArgs e) { UpdateEmployees(); }
        private void Filter_SelectionChanged(object sender, SelectionChangedEventArgs e) { UpdateEmployees(); }
        private void RefreshButton_Click(object sender, RoutedEventArgs e) { if (CanManage()) LoadEmployees(); }
        private void NewButton_Click(object sender, RoutedEventArgs e)
        {
            if (!CanManage()) return;
            ClearEditor();
            ShowEditor();
        }

        private void ShowEditor()
        {
            ListPanel.Visibility = Visibility.Collapsed;
            EditorPanel.Visibility = Visibility.Visible;
            EditorPanel.ScrollToTop();
            FullNameBox.Focus();
        }

        private void CloseEditor()
        {
            ClearEditor();
            EditorPanel.Visibility = Visibility.Collapsed;
            ListPanel.Visibility = Visibility.Visible;
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            CloseEditor();
        }

        private void ClearEditor()
        {
            selectedId = null;
            EditorTitle.Text = "Новый сотрудник";
            FullNameBox.Clear(); PositionBox.Clear(); PhoneBox.Clear(); LoginBox.Clear();
            PasswordBox.Clear(); ConfirmBox.Clear();
            ActiveBox.IsChecked = true;
            RoleBox.SelectedItem = (RoleBox.ItemsSource as List<Roles>)?.FirstOrDefault(x => x.RoleName == "Пользователь");
        }

        private void EditButton_Click(object sender, RoutedEventArgs e)
        {
            if (!CanManage()) return;
            var employee = EmployeesGrid.SelectedItem as Employees;
            if (employee == null) { MessageBox.Show("Выберите сотрудника.", "Сотрудники", MessageBoxButton.OK, MessageBoxImage.Information); return; }
            selectedId = employee.EmployeeID;
            EditorTitle.Text = "Редактирование сотрудника";
            FullNameBox.Text = employee.FullName;
            PositionBox.Text = employee.Position;
            PhoneBox.Text = employee.Phone;
            LoginBox.Text = employee.Login;
            RoleBox.SelectedValue = employee.RoleID;
            ActiveBox.IsChecked = employee.IsActive;
            PasswordBox.Clear(); ConfirmBox.Clear();
            ShowEditor();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (!CanManage()) return;
            string name = FullNameBox.Text.Trim();
            string position = PositionBox.Text.Trim();
            string phone = PhoneBox.Text.Trim();
            string login = LoginBox.Text.Trim();
            var role = RoleBox.SelectedItem as Roles;
            bool active = ActiveBox.IsChecked == true;
            bool changePassword = !selectedId.HasValue || PasswordBox.Password.Length > 0 || ConfirmBox.Password.Length > 0;
            var errors = new StringBuilder();
            if (name.Length == 0 || name.Length > 150) errors.AppendLine("Укажите ФИО до 150 символов.");
            if (position.Length == 0 || position.Length > 50) errors.AppendLine("Укажите должность до 50 символов.");
            if (login.Length == 0 || login.Length > 50 || !Regex.IsMatch(login, @"^[A-Za-z0-9_.-]+$")) errors.AppendLine("Логин: до 50 латинских букв, цифр, точек, дефисов и подчёркиваний.");
            if (phone.Length > 0 && (phone.Length > 20 || !Regex.IsMatch(phone, @"^\+?[0-9() -]+$") || phone.Count(char.IsDigit) < 10 || phone.Count(char.IsDigit) > 15)) errors.AppendLine("Телефон должен содержать от 10 до 15 цифр.");
            if (role == null) errors.AppendLine("Выберите роль.");
            if (changePassword)
            {
                string error = PasswordHelper.ValidatePassword(PasswordBox.Password, ConfirmBox.Password);
                if (error != null) errors.AppendLine(error);
            }
            if (selectedId == Core.CurrentUser.EmployeeID && (!active || role == null || role.RoleName != "Администратор"))
                errors.AppendLine("Нельзя отключить свою учётную запись или изменить свою роль администратора.");
            if (errors.Length > 0) { MessageBox.Show(errors.ToString(), "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning); return; }
            if (selectedId.HasValue && changePassword && MessageBox.Show("Заменить пароль выбранного сотрудника?", "Смена пароля", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes) return;
            try
            {
                using (var db = new DB_Zhurikhin_AutoDealerManagementEntities())
                using (var transaction = db.Database.BeginTransaction(System.Data.IsolationLevel.Serializable))
                {
                    int currentId = selectedId ?? 0;
                    if (db.Employees.Any(x => x.Login == login && x.EmployeeID != currentId))
                    { MessageBox.Show("Этот логин уже занят.", "Проверка данных"); return; }
                    var employee = selectedId.HasValue ? db.Employees.SingleOrDefault(x => x.EmployeeID == selectedId.Value) : new Employees();
                    if (employee == null) { MessageBox.Show("Сотрудник уже удалён. Обновите список."); return; }
                    if (selectedId.HasValue && employee.IsActive && employee.Roles.RoleName == "Администратор" && (!active || role.RoleName != "Администратор") && !db.Employees.Any(x => x.EmployeeID != employee.EmployeeID && x.IsActive && x.Roles.RoleName == "Администратор"))
                    { MessageBox.Show("Нельзя отключить последнего администратора."); return; }
                    employee.FullName = name; employee.Position = position; employee.Phone = phone.Length == 0 ? null : phone;
                    employee.Login = login; employee.RoleID = role.RoleID; employee.IsActive = active;
                    if (changePassword) employee.PasswordHash = PasswordHelper.HashPassword(PasswordBox.Password);
                    if (!selectedId.HasValue) db.Employees.Add(employee);
                    db.SaveChanges(); transaction.Commit();
                    if (employee.EmployeeID == Core.CurrentUser.EmployeeID)
                        Core.CurrentUser = db.Employees.Include(x => x.Roles).AsNoTracking().Single(x => x.EmployeeID == employee.EmployeeID);
                }
                MessageBox.Show("Сотрудник сохранён.", "Сотрудники", MessageBoxButton.OK, MessageBoxImage.Information);
                LoadEmployees();
            }
            catch (Exception) { MessageBox.Show("Не удалось сохранить сотрудника. Проверьте подключение и уникальность логина.", "Сотрудники", MessageBoxButton.OK, MessageBoxImage.Warning); }
        }

        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            if (!CanManage()) return;
            var selected = EmployeesGrid.SelectedItem as Employees;
            if (selected == null) { MessageBox.Show("Выберите сотрудника."); return; }
            if (selected.EmployeeID == Core.CurrentUser.EmployeeID) { MessageBox.Show("Нельзя удалить свою учётную запись."); return; }
            if (MessageBox.Show("Удалить сотрудника «" + selected.FullName + "»?", "Удаление", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes) return;
            try
            {
                using (var db = new DB_Zhurikhin_AutoDealerManagementEntities())
                {
                    var employee = db.Employees.SingleOrDefault(x => x.EmployeeID == selected.EmployeeID);
                    if (employee == null) { LoadEmployees(); return; }
                    if (employee.Deals.Any() || employee.Deliveries.Any() || employee.OrderWorks.Any() || employee.ServiceOrders.Any())
                    { MessageBox.Show("У сотрудника есть связанные документы. Вместо удаления отключите учётную запись."); return; }
                    db.Employees.Remove(employee); db.SaveChanges();
                }
                MessageBox.Show("Сотрудник удалён."); LoadEmployees();
            }
            catch (Exception) { MessageBox.Show("Не удалось удалить сотрудника. Проверьте подключение и связанные документы."); }
        }
    }
}
