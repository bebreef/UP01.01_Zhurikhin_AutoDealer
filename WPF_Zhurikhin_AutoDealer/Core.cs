namespace WPF_Zhurikhin_AutoDealer
{
    public class Core
    {
        public static DB_Zhurikhin_AutoDealerManagementEntities Context = new DB_Zhurikhin_AutoDealerManagementEntities();
        public static Employees CurrentUser { get; set; }

        public static bool IsCustomer()
        {
            return CurrentUser?.Roles?.RoleName == "Пользователь";
        }

        public static bool CanEditData()
        {
            string role = CurrentUser?.Roles?.RoleName;
            return role == "Администратор" || role == "Менеджер по продажам";
        }
    }
}
