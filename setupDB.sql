CREATE TABLE Address (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    Street VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    Zip INT
);

CREATE TABLE Person (
    PersonID INT PRIMARY KEY AUTO_INCREMENT,
    Address INT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    FOREIGN KEY (Address) REFERENCES Address(AddressID)
);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    PersonID INT,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

CREATE TABLE Warehouse (
    WarehouseID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255),
    Employee INT,
    Address INT,
    FOREIGN KEY (Employee) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (Address) REFERENCES Address(AddressID)
);

CREATE TABLE Depot (
    DepotID INT PRIMARY KEY AUTO_INCREMENT,
    Address INT,
    FOREIGN KEY (Address) REFERENCES Address(AddressID)
);

CREATE TABLE Vendor (
    VendorID INT PRIMARY KEY AUTO_INCREMENT,
    Address INT,
    Name VARCHAR(255),
    FOREIGN KEY (Address) REFERENCES Address(AddressID)
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255),
    Expiration DATE,
    ReceivedDate DATETIME,
    Vendor INT,
    FOREIGN KEY (Vendor) REFERENCES Vendor(VendorID)
);

CREATE TABLE VendorProducts (
    Vendor INT,
    Product INT,
    PRIMARY KEY (Vendor, Product),
    FOREIGN KEY (Vendor) REFERENCES Vendor(VendorID),
    FOREIGN KEY (Product) REFERENCES Product(ProductID)
);

CREATE TABLE Shipment (
    ShipmentID INT PRIMARY KEY AUTO_INCREMENT,
    OriginType ENUM('Vendor', 'Warehouse', 'Depot'),
    OriginID INT,
    DestinationType ENUM('Warehouse', 'Depot'),
    DestinationID INT,
    ShipmentDate DATETIME,
    ArrivalDate DATETIME,
    Status ENUM('Pending', 'In Transit', 'Delivered'),
    CHECK ((OriginType = 'Vendor' AND OriginID IN (SELECT VendorID FROM Vendor)) 
        OR (OriginType = 'Warehouse' AND OriginID IN (SELECT WarehouseID FROM Warehouse))
        OR (OriginType = 'Depot' AND OriginID IN (SELECT DepotID FROM Depot))),
    CHECK ((DestinationType = 'Warehouse' AND DestinationID IN (SELECT WarehouseID FROM Warehouse))
        OR (DestinationType = 'Depot' AND DestinationID IN (SELECT DepotID FROM Depot)))
);

CREATE TABLE ShipmentDetails (
    ShipmentID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (ShipmentID, ProductID),
    FOREIGN KEY (ShipmentID) REFERENCES Shipment(ShipmentID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
