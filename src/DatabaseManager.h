// databasemanager.h

#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QSqlTableModel>
#include <QSqlRecord>
#include <QFile>
#include <QDate>
#include<QFileInfo>
#include "src/singleton.h"
class DatabaseManager : public QObject
{
    Q_OBJECT

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    Q_INVOKABLE QVariantMap auth(const QString &account, const QString &password);
    Q_INVOKABLE QList<QVariantMap> get_tbl_data(const QString &tableName);
    Q_INVOKABLE bool deleteRoom(const QString &roomId);
    Q_INVOKABLE QString getRoomPhoto(const QString &roomId);
    Q_INVOKABLE bool addRoom(const QString &roomID, const QString &roomName, int capacity, double roomArea, const QString &description, const QString &photoPath);
    Q_INVOKABLE bool updateRoom(const QString &roomID, const QString &roomName, int capacity, double roomArea, const QString &description, const QString &photoPath);
    Q_INVOKABLE QList<QVariantMap> searchRooms(const QString &searchText);
    Q_INVOKABLE QString getReservationDate(const QString &reservationID);
    Q_INVOKABLE QList<QVariantMap> getApprovedReservationsData(const QString &status);
    Q_INVOKABLE QList<QVariantMap> getApprovedReservationsDataUsers(const QString &status, const QString &userID);
    Q_INVOKABLE bool cancelReservation(const QString &reservationID);

private:
    QSqlDatabase db;
};

#endif // DATABASEMANAGER_H
