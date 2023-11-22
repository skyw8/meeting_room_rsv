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
#include <QFileInfo>
#include "src/singleton.h"
class DatabaseManager : public QObject
{
    Q_OBJECT

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    Q_INVOKABLE QVariantMap auth(const QString &account, const QString &password);
    Q_INVOKABLE QList<QVariantMap> getRooms();
    Q_INVOKABLE bool delRoom(const QString &roomId);
    Q_INVOKABLE QString getRoomPhoto(const QString &roomId);
    Q_INVOKABLE bool addRoom(const QString &roomID, const QString &roomName, int capacity, double roomArea, const QString &description, const QString &photoPath);
    Q_INVOKABLE bool updateRoom(const QString &roomID, const QString &roomName, int capacity, double roomArea, const QString &description, const QString &photoPath);
    Q_INVOKABLE QList<QVariantMap> searchRooms(const QString &searchText);
    Q_INVOKABLE QString getRsvDate(const QString &reservationID);
    Q_INVOKABLE QStringList getLogs(const QString &reservationID);
    Q_INVOKABLE QList<QVariantMap> getApprovedRsv(const QString &status);
    Q_INVOKABLE QList<QVariantMap> getApprovedRsvUsers(const QString &status, const QString &userID);
    Q_INVOKABLE bool cancelRsv(const QString &reservationID);
    Q_INVOKABLE bool agreeRsv(const QString &reservationID, const QString &approverID);
    Q_INVOKABLE bool rejectRsv(const QString &reservationID, const QString &approverID, const QString &rejectionReason);
    Q_INVOKABLE QList<QVariantMap> filterRooms(int capacity, const QDate &date, const QString &startTimeText, const QString &endTimeText);
    Q_INVOKABLE bool addRsv(const QString &userID, const QString &roomID, const QString &dateStr, const QString &startTimeStr, const QString &endTimeStr, int attendance, const QString &meetingTheme);

private:
    QSqlDatabase db;
};

#endif // DATABASEMANAGER_H
