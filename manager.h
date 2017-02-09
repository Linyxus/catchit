#ifndef MANAGER_H
#define MANAGER_H

#include <QObject>
#include <QVector>

class Manager : public QObject
{
    Q_OBJECT
public:
    Manager(int size, QObject *parent = 0);
    Q_INVOKABLE void reload(int size);
    Q_INVOKABLE void setItPos(int r, int c);
    Q_INVOKABLE void add(int _r, int _c);
    Q_INVOKABLE bool check(int r, int c);
    Q_INVOKABLE int getNextRow() const { return nextrow; }
    Q_INVOKABLE int getNextCol() const { return nextcol; }
signals:
    void requestReload();
private:
    int size;
    int barrier[55][55];
    int itcol;
    int itrow;
    int nextcol;
    int nextrow;
};

#endif // MANAGER_H
