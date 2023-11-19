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
    Q_INVOKABLE QList<QVariantMap> get_tbl_data(const QString &tableName);
    Q_INVOKABLE bool deleteRoom(const QString &roomId);
    Q_INVOKABLE QString getRoomPhoto(const QString &roomId);
    Q_INVOKABLE bool addRoom(const QString &roomID, const QString &roomName, int capacity, double roomArea, const QString &description, const QString &photoPath);
    Q_INVOKABLE bool updateRoom(const QString &roomID, const QString &roomName, int capacity, double roomArea, const QString &description, const QString &photoPath);
    Q_INVOKABLE QList<QVariantMap> searchRooms(const QString &searchText);
    Q_INVOKABLE QString getReservationDate(const QString &reservationID);
    Q_INVOKABLE QStringList getApprovalDetail(const QString &reservationID);
    Q_INVOKABLE QList<QVariantMap> getApprovedReservationsData(const QString &status);
    Q_INVOKABLE QList<QVariantMap> getApprovedReservationsDataUsers(const QString &status, const QString &userID);
    Q_INVOKABLE bool cancelReservation(const QString &reservationID);
    Q_INVOKABLE bool agreeReservation(const QString &reservationID, const QString &approverID);
    Q_INVOKABLE bool rejectReservation(const QString &reservationID, const QString &approverID, const QString &rejectionReason);
    Q_INVOKABLE QList<QVariantMap> filterMeetingRooms(int capacity, const QDate &date, const QString &startTimeText, const QString &endTimeText);
    Q_INVOKABLE bool addReservation(const QString &userID, const QString &roomID, const QString &dateStr, const QString &startTimeStr, const QString &endTimeStr, int attendance, const QString &meetingTheme);

private:
    QSqlDatabase db;
};

#endif // DATABASEMANAGER_H
