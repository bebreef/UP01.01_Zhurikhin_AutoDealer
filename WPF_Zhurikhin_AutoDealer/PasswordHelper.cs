using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace WPF_Zhurikhin_AutoDealer
{
    public static class PasswordHelper
    {
        private const int Iterations = 600000;
        private const int SaltSize = 16;
        private const int HashSize = 32;

        public static string ValidatePassword(string password, string confirmation)
        {
            if (string.IsNullOrWhiteSpace(password))
                return "Введите пароль.";

            if (password.Length < 6 || password.Length > 128)
                return "Пароль должен содержать от 6 до 128 символов.";

            bool hasDigit = false;

            foreach (char symbol in password)
            {
                if (symbol >= '0' && symbol <= '9')
                    hasDigit = true;
                else if (!((symbol >= 'A' && symbol <= 'Z') || (symbol >= 'a' && symbol <= 'z')))
                    return "Используйте в пароле только латинские буквы и цифры.";
            }

            if (!hasDigit)
                return "Добавьте в пароль хотя бы одну цифру.";

            if (password != confirmation)
                return "Пароли не совпадают.";

            return null;
        }

        public static string HashPassword(string password)
        {
            byte[] salt = new byte[SaltSize];

            using (var random = RandomNumberGenerator.Create())
            {
                random.GetBytes(salt);
            }

            byte[] hash;

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256))
            {
                hash = pbkdf2.GetBytes(HashSize);
            }

            return $"PBKDF2-SHA256${Iterations}${Convert.ToBase64String(salt)}${Convert.ToBase64String(hash)}";
        }

        public static bool VerifyPassword(string password, string storedHash)
        {
            if (password == null || string.IsNullOrWhiteSpace(storedHash))
            {
                return false;
            }

            string[] parts = storedHash.Split('$');

            if (parts.Length != 4 || parts[0] != "PBKDF2-SHA256")
            {
                return false;
            }

            if (!int.TryParse(parts[1], out int iterations) || iterations != Iterations)
            {
                return false;
            }

            try
            {
                byte[] salt = Convert.FromBase64String(parts[2]);
                byte[] expectedHash = Convert.FromBase64String(parts[3]);

                if (salt.Length != SaltSize || expectedHash.Length != HashSize)
                {
                    return false;
                }

                byte[] actualHash;

                using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations, HashAlgorithmName.SHA256))
                {
                    actualHash = pbkdf2.GetBytes(HashSize);
                }

                int difference = 0;

                for (int i = 0; i < HashSize; i++)
                {
                    difference |= actualHash[i] ^ expectedHash[i];
                }

                return difference == 0;
            }
            catch (FormatException)
            {
                return false;
            }
        }
    }
}