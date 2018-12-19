using System;

class Program
{
    static bool Opposites(char a, char b)
    {
        return (a == (b - ('a' - 'A'))) || (b == (a - ('a' - 'A')));
    }

    static void Main()
    {
        string input = "";
        string current = System.IO.File.ReadAllText("input").Trim();

        while (input.Length != current.Length)
        {
            input = current;
            current = "";
            for (int i = 0; i < input.Length; i++)
            {
                if (i + 1 < input.Length && Opposites(input[i], input[i + 1]))
                    i++;
                else
                    current += input[i];
            }
        }
        System.Console.WriteLine(input.Length);
    }
}
