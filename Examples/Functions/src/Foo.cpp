#include <iostream>

struct SomeStruct
{
    char a;
    unsigned int b;
    unsigned int c;
    char d;
};

extern "C" int GetSumAsm(unsigned int a, unsigned int b, unsigned int c, unsigned int d, unsigned char e, unsigned int f);
extern "C" void ModifySomeStructAsm(SomeStruct & s);

int Foo(int a, int b)
{
    return 0;
}

extern "C" int GetSum(unsigned int a, unsigned int b, unsigned int c, unsigned int d, unsigned char e, unsigned int f)
{
    unsigned int sum = GetSumAsm(a, b, c, d, e, f);
    return sum;
}

extern "C" void ModifySomeStruct(SomeStruct& s)
{
    s.a++;
    s.b++;
    s.c++;
    s.d++;
    ModifySomeStructAsm(s);
}

//void main()
//{
//    auto a = sizeof(SomeStruct);
//    return;
//}