
#include "DatabaseManager.h"

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent)
{
    // 设置数据库连接参数
    db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("localhost");
    db.setDatabaseName("meeting_room_rsv");
    db.setUserName("root");
    db.setPassword("1234");

    if (!db.open())
    {
        qDebug() << "Database connection error:" << db.lastError().text();
    }

    qDebug() << "Database connection success";
}

QVariantMap DatabaseManager::auth(const QString &account, const QString &password)
{
    QVariantMap userInfo;
    QSqlQuery query(db);
    query.prepare("SELECT * FROM Users WHERE UserName = :username AND userPassword = :password");
    query.bindValue(":username", account);
    query.bindValue(":password", password);

    if (!query.exec()) {
        qDebug() << "Query execution error:" << query.lastError().text();
        userInfo.insert("isValid", false);
        return userInfo;
    }

    if (query.next()) {
        QSqlRecord record = query.record();
        for (int i = 0; i < record.count(); i++) {
            userInfo.insert(record.fieldName(i), query.value(i));
        }
        userInfo.insert("isValid", true); // 添加验证成功的标记
    } else {
        userInfo.insert("isValid", false); // 添加验证失败的标记
    }

    return userInfo;
}




QList<QVariantMap> DatabaseManager::getRooms()
{
    QList<QVariantMap> dataList;
    QSqlQuery query(db);
    if (query.exec(QString("SELECT * FROM MeetingRooms"))) {
        QSqlRecord record = query.record();
        
        while (query.next()) {
            QVariantMap rowData;
            for (int i = 0; i < record.count(); ++i) {
                QString fieldName = record.fieldName(i);
                QVariant value = query.value(i);
                rowData.insert(fieldName, value);
            }
            dataList.append(rowData);
        }
    } else {
        qDebug() << "Query failed:" << query.lastError().text();
    }

    return dataList;
}

bool DatabaseManager::delRoom(const QString &roomId)
{
    QSqlQuery query(db);
    query.prepare("DELETE FROM MeetingRooms WHERE RoomID = :roomId");
    query.bindValue(":roomId", roomId);

    if (!query.exec()) {
        qDebug() << "Delete failed:" << query.lastError().text();
        return false;
    }

    return true;
}

QString DatabaseManager::getRoomPhoto(const QString &roomId)
{
    QSqlQuery query(db);
    query.prepare("SELECT Photo FROM MeetingRooms WHERE RoomID = :roomId");
    query.bindValue(":roomId", roomId);

    if (!query.exec()) {
        qDebug() << "Query failed:" << query.lastError().text();
        return QString();
    }

    if (query.next()) {
        QByteArray imageData = query.value(0).toByteArray();

        // 自动判断图像类型
        QString type;
        if (imageData.startsWith("\xFF\xD8")) {
            type = "jpeg";
        } else if (imageData.startsWith("\x89PNG")) {
            type = "png";
        } else if (imageData.startsWith("GIF87a") || imageData.startsWith("GIF89a")) {
            type = "gif";
            //不支持gif
            return QString();
        } else {
            type = "unknown";
            return QString();
        }

        QString encodedString = imageData.toBase64();
        return QString("data:image/" + type + ";base64,") + encodedString;
    }

    return QString();
}

// 在 DatabaseManager 类中添加如下函数定义
bool DatabaseManager::addRoom(const QString &roomID, const QString &roomName, int capacity, double roomArea, const QString &description, const QString &photoPath)
{
    QSqlQuery query(db);
    query.prepare("INSERT INTO MeetingRooms (RoomID, RoomName, Capacity, RoomArea, Description, Photo) VALUES (:roomID, :roomName, :capacity, :roomArea, :description, :photo)");
    query.bindValue(":roomID", roomID);
    query.bindValue(":roomName", roomName);
    query.bindValue(":capacity", capacity);
    query.bindValue(":roomArea", roomArea);
    query.bindValue(":description", description);

    // 检查photoPath是否为空
    if (!photoPath.isEmpty()) {
        QFile file(photoPath);
        if (file.open(QIODevice::ReadOnly)) {
            QByteArray imageData = file.readAll();
            query.bindValue(":photo", imageData);
            file.close();
        } else {
            qDebug() << "Failed to read image file:" << file.errorString();
            return false;
        }
    } else {
        // 如果photoPath为空，则插入NULL
        query.bindValue(":photo", QVariant(QVariant::ByteArray));
    }

    if (!query.exec()) {
        qDebug() << "Insert failed:" << query.lastError().text();
        return false;
    }

    return true;
}


bool DatabaseManager::updateRoom(const QString &roomID, const QString &roomName, int capacity, double roomArea, const QString &description, const QString &photoPath)
{
    QSqlQuery query(db);
    
    // 检查是否需要更新图片
    bool updatePhoto = QFileInfo(photoPath).exists();

    // 根据是否更新图片构建不同的 SQL 查询
    QString sql = "UPDATE MeetingRooms SET RoomName = :roomName, Capacity = :capacity, RoomArea = :roomArea, Description = :description";
    if (updatePhoto) {
        sql += ", Photo = :photo";
    }
    sql += " WHERE RoomID = :roomID";

    query.prepare(sql);
    query.bindValue(":roomID", roomID);
    query.bindValue(":roomName", roomName);
    query.bindValue(":capacity", capacity);
    query.bindValue(":roomArea", roomArea);
    query.bindValue(":description", description);

    // 如果需要更新图片，读取并设置图片数据
    if (updatePhoto) {
        QFile file(photoPath);
        if (file.open(QIODevice::ReadOnly)) {
            QByteArray imageData = file.readAll();
            query.bindValue(":photo", imageData);
            file.close();
        } else {
            qDebug() << "Failed to read image file:" << file.errorString();
            return false;
        }
    }

    if (!query.exec()) {
        qDebug() << "Update failed:" << query.lastError().text();
        return false;
    }

    return true;
}

QList<QVariantMap> DatabaseManager::searchRooms(const QString &searchText) {
    QList<QVariantMap> dataList;

    QSqlQuery query(db);
    query.prepare("SELECT * FROM MeetingRooms WHERE RoomID LIKE :searchText OR RoomName LIKE :searchText");
    query.bindValue(":searchText", "%" + searchText + "%");

    if (query.exec()) {
        QSqlRecord record = query.record();
        while (query.next()) {
            QVariantMap rowData;
            for (int i = 0; i < record.count(); ++i) {
                rowData.insert(record.fieldName(i), query.value(i));
            }
            dataList.append(rowData);
        }
    } else {
        qDebug() << "Search failed:" << query.lastError().text();
    }

    return dataList;
}
QString DatabaseManager::getRsvDate(const QString &reservationID)
{
    QSqlQuery query(db);
    query.prepare("SELECT ReservationDate FROM Reservations WHERE ReservationID = :reservationID");
    query.bindValue(":reservationID", reservationID);

    if (!query.exec()) {
        qDebug() << "Query failed:" << query.lastError().text();
        return QString();
    }

    if (query.next()) {
        QDate date = query.value(0).toDate();
        return date.toString("yyyy-MM-dd");
    }

    return QString();
}
QStringList DatabaseManager::getLogs(const QString &reservationID) {
    QSqlQuery query(db);
    query.prepare("SELECT ApprovalTime, ApproverID, RejectionReason FROM ApprovalLogs WHERE ReservationID = :reservationID");
    query.bindValue(":reservationID", reservationID);

    QStringList details;

    if (!query.exec()) {
        qDebug() << "Query failed:" << query.lastError().text();
        return details;  // 返回空列表
    }

    if (query.next()) {
        QDateTime approvalTime = query.value(0).toDateTime();
        QString approverID = query.value(1).toString();
        QString rejectionReason = query.value(2).toString();

        // 将每个字段转换为字符串
        details << approvalTime.toString(Qt::ISODate);  // 格式化日期时间
        details << approverID;  // 转换审批者ID为字符串
        details << rejectionReason;  // 转换拒绝理由为字符串
    } else {
        // 如果没有找到记录，则添加空字符串
        details << "" << "" << "";
    }

    return details;
}


QList<QVariantMap> DatabaseManager::getApprovedRsv(const QString &status)
{
    QList<QVariantMap> dataList;

    // 执行查询
    QSqlQuery query(db);
    QString queryString = QString("SELECT * FROM Reservations WHERE ReservationStatus = :status");
    query.prepare(queryString);
    query.bindValue(":status", status);

    if (query.exec()) {
        QSqlRecord record = query.record();
        
        while (query.next()) {
            QVariantMap rowData;
            for (int i = 0; i < record.count(); ++i) {
                QString fieldName = record.fieldName(i);
                QVariant value = query.value(i);
                rowData.insert(fieldName, value);
            }
            dataList.append(rowData);
        }
    } else {
        qDebug() << "Query failed:" << query.lastError().text();
    }

    return dataList;
}


QList<QVariantMap> DatabaseManager::getApprovedRsvUsers(const QString &status, const QString &userID) {
    QList<QVariantMap> dataList;

    // 执行查询
    QSqlQuery query(db);
    QString queryString = QString("SELECT * FROM Reservations WHERE ReservationStatus = :status AND UserID = :userID");
    query.prepare(queryString);
    query.bindValue(":status", status);
    query.bindValue(":userID", userID);  // 绑定 UserID

    if (query.exec()) {
        QSqlRecord record = query.record();
        
        while (query.next()) {
            QVariantMap rowData;
            for (int i = 0; i < record.count(); ++i) {
                QString fieldName = record.fieldName(i);
                QVariant value = query.value(i);
                rowData.insert(fieldName, value);
            }
            dataList.append(rowData);
        }
    } else {
        qDebug() << "Query failed:" << query.lastError().text();
    }

    return dataList;
}



bool DatabaseManager::cancelRsv(const QString &reservationID) {
    QSqlQuery query(db);
    query.prepare("UPDATE Reservations SET ReservationStatus = 'canceled' WHERE ReservationID = :reservationID");
    query.bindValue(":reservationID", reservationID);

    if (!query.exec()) {
        qDebug() << "Update failed:" << query.lastError().text();
        return false;
    }

    return true;
}
bool DatabaseManager::agreeRsv(const QString &reservationID, const QString &approverID) {
    QSqlDatabase transactionDatabase = QSqlDatabase::database();
    transactionDatabase.transaction(); // 开始一个新的事务

    QSqlQuery query(db);

    // 更新 Reservations 表
    query.prepare("UPDATE Reservations SET ReservationStatus = 'agree' WHERE ReservationID = :reservationID");
    query.bindValue(":reservationID", reservationID);
    if (!query.exec()) {
        qDebug() << "Update failed:" << query.lastError().text();
        transactionDatabase.rollback(); // 如果失败，则回滚事务
        return false;
    }

    // 插入 ApprovalLogs 表
    query.prepare("INSERT INTO ApprovalLogs (ReservationID, ApprovalTime, ApproverID) VALUES (:reservationID, NOW(), :approverID)");
    query.bindValue(":reservationID", reservationID);
    query.bindValue(":approverID", approverID);
    if (!query.exec()) {
        qDebug() << "Insert into ApprovalLogs failed:" << query.lastError().text();
        transactionDatabase.rollback(); // 如果失败，则回滚事务
        return false;
    }

    transactionDatabase.commit(); // 提交事务
    return true;
}

bool DatabaseManager::rejectRsv(const QString &reservationID, const QString &approverID, const QString &rejectionReason) {
    QSqlDatabase transactionDatabase = QSqlDatabase::database();
    transactionDatabase.transaction(); // 开始一个新的事务

    QSqlQuery query(db);

    // 更新 Reservations 表
    query.prepare("UPDATE Reservations SET ReservationStatus = 'reject' WHERE ReservationID = :reservationID");
    query.bindValue(":reservationID", reservationID);
    if (!query.exec()) {
        qDebug() << "Update failed:" << query.lastError().text();
        transactionDatabase.rollback(); // 如果失败，则回滚事务
        return false;
    }

    // 插入 ApprovalLogs 表
    query.prepare("INSERT INTO ApprovalLogs (ReservationID, ApprovalTime, ApproverID, RejectionReason) VALUES (:reservationID, NOW(), :approverID, :rejectionReason)");
    query.bindValue(":reservationID", reservationID);
    query.bindValue(":approverID", approverID);
    query.bindValue(":rejectionReason", rejectionReason);
    if (!query.exec()) {
        qDebug() << "Insert into ApprovalLogs failed:" << query.lastError().text();
        transactionDatabase.rollback(); // 如果失败，则回滚事务
        return false;
    }

    transactionDatabase.commit(); // 提交事务
    return true;
}


QList<QVariantMap> DatabaseManager::filterRooms(int capacity, const QDate &date, const QString &startTimeText, const QString &endTimeText) {
    const QTime startTime = QTime::fromString(startTimeText + ":00:00", "HH:mm:ss");
    const QTime endTime = QTime::fromString(endTimeText + ":00:00", "HH:mm:ss");
    QList<QVariantMap> availableRooms;
    QSqlQuery query(db);
    query.prepare("SELECT * FROM MeetingRooms WHERE Capacity >= :capacity AND RoomID NOT IN "
                  "(SELECT RoomID FROM Reservations WHERE ReservationDate = :date AND "
                  "ReservationStatus = 'agree' AND"
                  "((StartTime <= :startTime AND EndTime > :startTime) OR "
                  "(StartTime < :endTime AND EndTime >= :endTime) OR "
                  "(StartTime >= :startTime AND EndTime <= :endTime)))");
    query.bindValue(":capacity", capacity);
    query.bindValue(":date", date);
    query.bindValue(":startTime", startTime);
    query.bindValue(":endTime", endTime);

    if (query.exec()) {
        QSqlRecord record = query.record();
        while (query.next()) {
            QVariantMap roomData;
            for (int i = 0; i < record.count(); ++i) {
                roomData.insert(record.fieldName(i), query.value(i));
            }
            availableRooms.append(roomData);
        }
    } else {
        qDebug() << "Query failed:" << query.lastError().text();
    }

    return availableRooms;
}

bool DatabaseManager::addRsv(const QString &userID, const QString &roomID, const QString &dateStr, const QString &startTimeStr, const QString &endTimeStr, int attendance, const QString &meetingTheme) {
    QSqlQuery query(db);

    // 转换日期和时间为适合数据库的格式
    QDate date = QDate::fromString(dateStr, "yyyy-MM-dd");
    QTime startTime = QTime::fromString(startTimeStr + ":00:00", "HH:mm:ss");
    QTime endTime = QTime::fromString(endTimeStr + ":00:00", "HH:mm:ss");

    query.prepare("INSERT INTO Reservations (ReservationID, UserID, RoomID, ReservationDate, StartTime, EndTime, Attendance, MeetingTheme, ReservationStatus) "
                  "VALUES (UUID(), :userID, :roomID, :date, :startTime, :endTime, :attendance, :meetingTheme, 'unapproved')");
    query.bindValue(":userID", userID);
    query.bindValue(":roomID", roomID);
    query.bindValue(":date", date);
    query.bindValue(":startTime", startTime);
    query.bindValue(":endTime", endTime);
    query.bindValue(":attendance", attendance);
    query.bindValue(":meetingTheme", meetingTheme);

    if (!query.exec()) {
        qDebug() << "Insert failed:" << query.lastError().text();
        return false;
    }

    return true;
}
