//
//  main.cpp
//  Helo
//
//

#include <iostream>

#include "helo.h"
std::string Hungry(std::string);

int main() {
    using namespace std;
    cout << "Hi";
    cout << endl;
    cout << "I wrote you a program" << endl;
    string hun;
    cout <<"enter y if hungry, n if not";
    cin >> hun;
    std::string answer= Hungry(hun);
    cout << answer;
    cout <<endl;
    return 0;
    

}

std::string Hungry(std::string j)
{
    if (j=="y"){
        return "Let's get food";
    }
       else if (j=="n"){
            return "Ok";
        }
       else{
           return "you typed an incorrect key";
       }
        }
