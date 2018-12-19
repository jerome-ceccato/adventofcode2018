using System;

class Program
{
    static bool Opposites(char a, char b)
    {
        return (a == (b - ('a' - 'A'))) || (b == (a - ('a' - 'A')));
    }

    static int MinimalLength(string input)
    {
        string current = "";

        while (current.Length != input.Length)
        {
            current = input;
            input = "";
            for (int i = 0; i < current.Length; i++)
            {
                if (i + 1 < current.Length && Opposites(current[i], current[i + 1]))
                    i++;
                else
                    input += current[i];
            }
        }
        return current.Length;
    }

    static void Main()
    {
        string input = System.IO.File.ReadAllText("input").Trim();
        int min = int.MaxValue;

        for (char a = 'A'; a <= 'Z'; a++)
        {
            int len = MinimalLength(input.Replace($"{a}", String.Empty).Replace($"{(char)(a - 'A' + 'a')}", String.Empty));

            if (len < min)
                min = len;
        }
        System.Console.WriteLine(min);
    }
}
