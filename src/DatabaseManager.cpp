
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

bool DatabaseManager::auth(const QString &account, const QString &password)
{
    QSqlQuery query(db);
    query.prepare("SELECT * FROM users WHERE username = :username AND userPassword = :password");
    query.bindValue(":username", account);
    query.bindValue(":password", password);
    
    if (!db.isOpen())
    {
        qDebug() << "Database connection is not open";
        return false;
    }
    if (!query.exec())
    {
        qDebug() << "Query execution error:" << query.lastError().text();
        return false;
    }
    return query.next();
}



QList<QVariantMap> DatabaseManager::get_tbl_data(const QString &tableName)
{
    QList<QVariantMap> dataList;

    // 执行查询
    QSqlQuery query(db);
    if (query.exec(QString("SELECT * FROM %1").arg(tableName))) {
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

bool DatabaseManager::deleteRoom(const QString &roomId)
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
        qDebug() << encodedString;
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
QString DatabaseManager::getReservationDate(const QString &reservationID)
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
