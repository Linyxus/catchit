#include "manager.h"
#include <cstring>
#include <algorithm>
#include <queue>
#include <QDebug>

Manager::Manager(int size, QObject *parent /* = 0*/)
    : QObject(parent)
{
    this->size = size;
    for (int i = 0; i < size; i++) {
        memset(barrier[i], 0, sizeof barrier[i]);
    }
}

void Manager::reload(int size)
{
    this->size = size;
    for (int i = 0; i < size; i++) {
        memset(barrier[i], 0, sizeof barrier[i]);
    }
    emit requestReload();
}

void Manager::setItPos(int r, int c)
{
    itrow = r;
    itcol = c;
}

void Manager::add(int _r, int _c)
{

    if (itrow == 0 || itrow == size-1 || itcol == 0 || itcol == size-1) {
        nextrow = nextcol = -2; //reach the edge, It win
        return;
    }
    barrier[_r][_c] = 1;
    int d[size][size];
    for (int i = 0; i < size; i++) {
        memset(d[i], 0, sizeof d[i]);
    }

    //#1 init d
    for (int r = 0; r < size; r++) {
        for (int c = 0; c < size; c++) {
            if (barrier[r][c]) {
                d[r][c] = -1; //never go here
                for (int dr = -5; dr <= 5; dr++) { //every barrier is like a fire, keep away from them
                    for (int dc = -5; dc <= 5; dc++) {
                        if (dr == 0 && dc == 0) continue;
                        int rr = r + dr;
                        int cc = c + dc;
                        if (rr < 0 || rr >= size || cc < 0 || cc >= size) continue; //out of range
                        if (barrier[rr][cc]) continue; //also a barrier-

                        d[rr][cc] += 6 - std::max(std::abs(dr), std::abs(dc));
                    }
                }
            }
        }
    }

    //#2 spfa
    struct Point
    {
        int row, col;
    };
    int inq[size][size];
    int res[size][size];
    Point p[size][size];
    for (int i = 0; i < size; i++)
        memset(inq[i], 0, sizeof inq[i]);
    for (int i = 0; i < size; i++)
        memset(res[i], -1, sizeof res[i]);
    std::queue<Point> q;
    Point u;
    u.row = itrow; u.col = itcol;
    q.push(u); inq[itrow][itcol] = 1; res[itrow][itcol] = d[itrow][itcol];
    int mr[] = {0, 0, -1, 1}; //movement
    int mc[] = {1, -1, 0, 0};
    while (!q.empty()) {
        u = q.front(); q.pop();
        inq[u.row][u.col] = false;
        for (int i = 0; i < 4; i++) {
            int rr = u.row + mr[i];
            int cc = u.col + mc[i];
            if (rr < 0 || rr >= size || cc < 0 || cc >= size) continue; //out of range
            if (d[rr][cc] == -1) continue; //barrier
            if (res[rr][cc] == -1 || res[rr][cc] > res[u.row][u.col] + d[rr][cc]) {
                if (u.row == itrow && u.col == itcol) { //this is source
                    Point po; po.row = rr; po.col = cc;
                    p[rr][cc] = po;
                }
                else {
                    p[rr][cc] = p[u.row][u.col];
                }
                res[rr][cc] = res[u.row][u.col] + d[rr][cc];
                if (!inq[rr][cc]) {
                    Point v;
                    v.row = rr; v.col = cc;
                    q.push(v);
                    inq[rr][cc] = true;
                }
            }
        }
    }

//    //#2' Test
//    qDebug() << "### SPFA Info [" << size << "]\n";
//    for (int i = 0; i < size; i++) {
//        for (int j = 0; j < size; j++) {
//            qDebug().nospace() << res[i][j];
//        }
//    }

    //#3 find out the shortest path towards edge
    int er[] = { 0, size-1, -1, -1};
    int ec[] = { -1, -1, 0, size-1};
    int lowres = -1;
    int lowr, lowc;
    for (int i = 0; i < 4; i++) {
        int err = er[i];
        int ecc = ec[i];
        if (err == -1) {
            for (int r = 0; r < size; r++) {
                if (res[r][ecc] == -1) continue;
                if (lowres == -1 || lowres > res[r][ecc]) {
                    lowres = res[r][ecc];
                    lowr = r;
                    lowc = ecc;
                }
            }
        }
        if (ecc == -1) {
            for (int c = 0; c < size; c++) {
                if (res[err][c] == -1) continue;
                if (lowres == -1 || lowres > res[err][c]) {
                    lowres = res[err][c];
                    lowr = err;
                    lowc = c;
                }
            }
        }
    }
    if (lowres == -1) {
        nextrow = nextcol = -1; //nowhere to go, player win
        return;
    }
    nextrow = p[lowr][lowc].row;
    nextcol = p[lowr][lowc].col;
    //#3' Test
    qDebug() << lowr << lowc;
    qDebug() << nextrow << nextcol;

    //#4 Update It Position
    setItPos(nextrow, nextcol);
}

bool Manager::check(int r, int c)
{
    if (r == itrow && c == itcol)
        return false;
    if (barrier[r][c])
        return false;
    return true;
}
