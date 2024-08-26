#ifndef SIDEBAR_H
#define SIDEBAR_H

#include <QObject>
#include <QString>

class Sidebar : public QObject
{
    Q_OBJECT
public:
    explicit Sidebar(QObject *parent = nullptr);

signals:
    void valueChanged(QString s);

public slots:
    void changeValue(int a);
};

#endif // SIDEBAR_H
