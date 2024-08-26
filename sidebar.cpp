#include "sidebar.h"
#include <QDebug>

Sidebar::Sidebar(QObject *parent): QObject{parent}
{

}

void Sidebar::changeValue(int a)
{
    qDebug() << "Sidebar::changeValue called with value:" << a;
    if(a==1)
    {
        emit valueChanged("value is 1 from c++");
    }
    else if(a==2)
    {
        emit valueChanged("value is 2 from c++");
    }
    else if(a==3)
    {
        emit valueChanged("value is 3 from c++");
    }
    else if(a==4)
    {
        emit valueChanged("value is 4 from c++");
    }
    else
    {
        emit valueChanged("value is 5 from c++");
    }

}
