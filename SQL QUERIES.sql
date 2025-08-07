CREATE DATABASE FA23_BSE_173_067
USE FA23_BSE_173_067

CREATE TABLE Customer (
    cust_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL CHECK (LEN(password) >= 8),
    phone_no VARCHAR(15) UNIQUE,
    date_of_birth DATE NOT NULL,
    reg_date DATE NOT NULL,
    account_status VARCHAR(20) NOT NULL CHECK (account_status IN ('active', 'inactive', 'banned'))
);

CREATE TABLE Admin (
    admin_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL CHECK (LEN(password) >= 8),
    phone_no VARCHAR(15) UNIQUE,
    date_of_birth DATE NOT NULL,
    date_of_joining DATE NOT NULL
);

CREATE TABLE ShippingAddress (
    s_id INT PRIMARY KEY,
    full_address varchar(500) NOT NULL,
    city VARCHAR(50) NOT NULL,
    province VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10),  
    landmark VARCHAR(100),
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(cust_id)
);

CREATE TABLE Category (
    c_id INT PRIMARY KEY,
    c_name VARCHAR(100) UNIQUE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'inactive'))
);

CREATE TABLE Product (
    p_id INT PRIMARY KEY,
    p_name VARCHAR(100) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL CHECK (base_price >= 0),
    image_url TEXT,
    status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'inactive')),
    category_id INT NOT NULL,
    customer_id INT NOT NULL,
    admin_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Category(c_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(cust_id),
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

CREATE TABLE ProductVariant (
    v_id INT PRIMARY KEY,
    var_price DECIMAL(10, 2) NOT NULL CHECK (var_price >= 0),
    color VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'inactive')),
    image_url TEXT,
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    p_id INT NOT NULL,
    FOREIGN KEY (p_id) REFERENCES Product(p_id)
);

CREATE TABLE ProductReview (
    rev_id INT PRIMARY KEY,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(100),
    written_review TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'visible' CHECK (status IN ('visible', 'hidden')),
    p_id INT NOT NULL,
    customer_id INT NOT NULL,
    FOREIGN KEY (p_id) REFERENCES Product(p_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(cust_id)
);

CREATE TABLE Customer_Order(
    order_no INT PRIMARY KEY,
    order_date DATE NOT NULL,
    shipping_fee DECIMAL(10, 2) DEFAULT 0 CHECK (shipping_fee >= 0),
    order_status VARCHAR(30) NOT NULL CHECK (order_status IN ('pending', 'shipped', 'delivered', 'cancelled')),
    tracking_id VARCHAR(100),
    payment_method VARCHAR(50),
    payment_type VARCHAR(50),
    payment_status VARCHAR(20) NOT NULL CHECK (payment_status IN ('pending', 'paid', 'failed')),
    transaction_id VARCHAR(100),
    order_note TEXT,
    customer_id INT NOT NULL,
    shipping_address_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(cust_id),
    FOREIGN KEY (shipping_address_id) REFERENCES ShippingAddress(s_id)
);

CREATE TABLE OrderCartItem (
    order_item_id INT PRIMARY KEY,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('Active', 'Ordered')) DEFAULT 'Active',
    order_no INT NOT NULL,
    v_id INT NOT NULL,
    FOREIGN KEY (order_no) REFERENCES Customer_Order(order_no),
    FOREIGN KEY (v_id) REFERENCES ProductVariant(v_id)
);

INSERT INTO Customer VALUES (1, 'Ali', 'Khan', 'user1@example.com', 'Password111', '03001234567', '1995-06-15', '2024-05-01', 'active'),
(2, 'Sara', 'Iqbal', 'user2@example.com', 'Password222', '03012345678', '1990-09-10', '2024-04-10', 'inactive'),
(3, 'Ahmed', 'Raza', 'user3@example.com', 'Password333', '03023456789', '1985-03-25', '2024-03-20', 'banned'),
(4, 'Hira', 'Shahid', 'user4@example.com', 'Password444', '03034567890', '1992-12-01', '2024-02-15', 'active'),
(5, 'Usman', 'Malik', 'user5@example.com', 'Password555', '03045678901', '1998-07-30', '2024-01-10', 'active');

INSERT INTO Admin VALUES (1, 'Zain', 'Ali', 'admin1@example.com', 'AdminPass222', '03111234567', '1988-01-10', '2022-03-01'),
(2, 'Rabia', 'Sheikh', 'admin2@example.com', 'AdminPass444', '03112345678', '1990-05-15', '2021-08-20'),
(3, 'Imran', 'Khalid', 'admin3@example.com', 'AdminPass666', '03123456789', '1985-11-22', '2023-06-10'),
(4, 'Nida', 'Yousaf', 'admin4@example.com', 'AdminPass888', '03134567890', '1992-04-18', '2020-12-05'),
(5, 'Hamza', 'Butt', 'admin5@example.com', 'AdminPass1010', '03145678901', '1987-08-09', '2023-01-01');

INSERT INTO ShippingAddress VALUES (1, 'House 123, Street 4, Model Town', 'Lahore', 'Punjab', '54000', 'Near Mall', 1),
(2, 'Flat 12B, Gulshan Apartments', 'Karachi', 'Sindh', '75500', 'Opposite Park', 2),
(3, 'House 99, Sector F', 'Islamabad', 'Capital', '44000', 'Next to Mosque', 3),
(4, 'Bungalow 5, Phase 6, DHA', 'Lahore', 'Punjab', '54810', 'Near School', 4),
(5, 'Plot 8, Johar Town', 'Lahore', 'Punjab', '54782', 'Beside Bank', 5);

INSERT INTO Category VALUES (101, 'Snackbait', 'active'),
(102, 'TrendToks', 'active'),
(103, 'Frame to Fame', 'active'),
(104, 'Sound Drip', 'active'),
(105, 'Core Things', 'active');

INSERT INTO Product VALUES
(2001, 'Frying Pan & Egg', 'Earrings that look like a frying pan with an egg', 750.00, 'frying_pan_egg_yellow.jpg', 'active', 101, 1, 1),
(2002, 'Butterfly Y2K Bling', 'Trendy Y2K butterfly-themed studs with sparkle.', 700.00, 'butterfly_bling_blue.jpg', 'active', 102, 2, 1),
(2003, 'Totoro Hug', 'A charm bracelet featuring Totoro', 800.00, 'totoro_bracelet_grey.jpg', 'active', 103, 1, 2),
(2004, 'Taylors Vault Lock', 'A music-inspired keychain referencing Taylor’s unreleased hits.', 500.00, 'vault_lock_rosegold.jpg', 'active', 104, 4, 2),
(2005, 'Angel Wing Drop', 'Elegant angelcore earrings with silver wing charms.', 850.00, 'angel_wing_silver.jpg', 'active', 105, 5, 3);
                

INSERT INTO ProductVariant VALUES
(301, 750.00, 'Yellow/White', 'active', 'frying_pan_egg_yellow.jpg', 20, 2001),
(302, 700.00, 'Blue Glitter', 'active', 'butterfly_bling_blue.jpg', 25, 2002),
(303, 800.00, 'Grey Charm', 'active', 'totoro_bracelet_grey.jpg', 15, 2003),
(304, 500.00, 'Rose Gold', 'active', 'vault_lock_rosegold.jpg', 30, 2004),
(305, 850.00, 'Silver', 'active', 'angel_wing_silver.jpg', 10, 2005),
(306, 850.00, 'Rose Gold', 'active', 'angel_wing_rosegold.jpg', 12, 2005);

INSERT INTO ProductReview VALUES
(401, 5, 'Super Cute!', 'Absolutely love these quirky earrings. Great quality too!', 'visible', 2001, 1),
(402, 4, 'Sparkly and Stylish', 'They look just like the pictures. Really cute!', 'visible', 2002, 2),
(403, 5, 'Nostalgic and Sweet', 'Perfect gift for Studio Ghibli fans. My sister adored it.', 'visible', 2003, 3),
(404, 3, 'Nice Concept', 'Cute design, but I wish the material was sturdier.', 'visible', 2004, 4),
(405, 5, 'Elegant Finish', 'These angel wings are just beautiful. Got so many compliments!', 'visible', 2005, 5);

INSERT INTO Customer_Order  VALUES
(501, '2025-05-01', 100.00, 'pending', 'TRK123456', 'Credit Card', 'Full Payment', 'pending', 'TXN1001', 'Please deliver after 5 PM.', 1, 1),
(502, '2025-05-03', 0.00, 'shipped', 'TRK123457', 'Cash on Delivery', 'Full Payment', 'pending', 'TXN1002', '', 2, 2),
(503, '2025-05-04', 50.00, 'delivered', 'TRK123458', 'Debit Card', 'Full Payment', 'paid', 'TXN1003', 'Gift wrap the item.', 3, 3),
(504, '2025-05-05', 75.00, 'cancelled', 'TRK123459', 'PayPal', 'Full Payment', 'failed', 'TXN1004', 'Customer requested cancellation.', 1, 4),
(505, '2025-05-06', 120.00, 'shipped', 'TRK123460', 'UPI', 'Full Payment', 'paid', 'TXN1005', '', 5, 5);

INSERT INTO OrderCartItem VALUES
(301, 2, 750.00, 'Ordered', 501, 301),  
(302, 1, 700.00, 'Ordered', 502, 302),  
(303, 1, 800.00, 'Ordered', 503, 303), 
(304, 1, 850.00, 'Active', 504, 304),   
(305, 1, 850.00, 'Ordered', 505, 305);  

--PROCEDURES
-- Shows which product variants were added by a specific admin in a specific category.
CREATE PROCEDURE CATEGORYMANAGEDBY @c_id INT, @admin_id INT AS
SELECT C.c_name AS [Category Name], P.p_name AS [Product Name], V.v_id AS [Variant #],
V.stock_quantity as [Stock], A.first_name + ' ' + A.last_name AS [Admin Name]
FROM Category C JOIN Product P
ON C.c_id = P.category_id
JOIN Admin A
ON A.admin_id = P.admin_id
join ProductVariant V
ON V.p_id = P.p_id
where A.admin_id = @admin_id AND C.c_id = @c_id;

EXEC CATEGORYMANAGEDBY 103, 2;


--Show all orders placed by a specific customer
CREATE PROCEDURE COSTUMERORDERHISTORY @cust_id INT AS
SELECT C.cust_id AS [Customer id], C.first_name + ' ' + C.last_name AS [Customer Name],O. order_no AS [Order no],
O.order_date AS [Order Date], O.order_status AS [order status],OC.quantity AS [Quantity], OC.unit_price AS [Price], P.p_name AS [Product Name],
V.v_id AS [Variant id]
FROM Customer C JOIN Customer_Order O
ON C.cust_id = O.customer_id
JOIN OrderCartItem OC
ON O.order_no = OC.order_no
JOIN ProductVariant V
ON OC.v_id = V.v_id
JOIN Product P
ON V.p_id = P.p_id
where C.cust_id = @cust_id;

EXEC COSTUMERORDERHISTORY 1;

--Retrieves detailed order info including customer, shipping, total items, costs, and grand total for a given order number. 
CREATE PROCEDURE OrderSummaryDetails @order_no INT AS
SELECT O.order_no, O.order_date, C.first_name + ' ' + C.last_name AS CustomerName, S.full_address, S.city, S.province,
       O.order_status, O.payment_method, O.payment_status, O.shipping_fee,
       (SELECT SUM(quantity) FROM OrderCartItem WHERE order_no = O.order_no) AS TotalItems,
       (SELECT SUM(quantity * unit_price) FROM OrderCartItem WHERE order_no = O.order_no) AS TotalAmount,
       O.shipping_fee + (SELECT SUM(quantity * unit_price) FROM OrderCartItem WHERE order_no = O.order_no) AS GrandTotal
FROM Customer_Order O
JOIN Customer C ON O.customer_id = C.cust_id
JOIN ShippingAddress S ON O.shipping_address_id = S.s_id
WHERE O.order_no = @order_no;

EXEC OrderSummaryDetails 501;

--Shows all visible reviews for a specific product, including reviewer’s name, product details, and the admin who manages the product.
CREATE PROCEDURE ProductReviewDetails @p_id INT AS
SELECT R.rev_id, R.rating, R.title, R.written_review, C.first_name + ' ' + C.last_name AS ReviewerName,
A.first_name + ' ' + A.last_name AS AdminName  --this is the admin who added the product
FROM ProductReview R
JOIN Customer C ON R.customer_id = C.cust_id
JOIN Product P ON R.p_id = P.p_id
JOIN Admin A ON P.admin_id = A.admin_id
WHERE R.p_id = @p_id AND R.status = 'visible';

EXEC ProductReviewDetails 2001;


--TOP RATED PRODUCT
CREATE PROCEDURE TopRatedProducts AS
SELECT P.p_name, AVG(R.rating) AS avg_rating
FROM ProductReview R
JOIN Product P ON R.p_id = P.p_id
GROUP BY P.p_name
HAVING AVG(R.rating) >= 4;

EXEC TopRatedProducts

--VIEWS
--This view displays all active products and their active variants along with stock, category, and the admin who added them.
CREATE VIEW ActiveProductInventory AS
SELECT P.p_id AS [Product ID], P.p_name AS [Product Name], V.v_id AS [Variant ID], V.color AS [Variant Color], 
       V.stock_quantity AS Stock, C.c_name AS Category, A.first_name + ' ' + A.last_name AS [Admin Name]
FROM Product P
JOIN ProductVariant V ON P.p_id = V.p_id
JOIN Category C ON P.category_id = C.c_id
JOIN Admin A ON P.admin_id = A.admin_id
WHERE P.status = 'active' AND V.status = 'active';

SELECT * FROM ActiveProductInventory;

-- this view shows a list of customer details and their associated shipping addresses.
CREATE VIEW CustomerShippingDetails AS
SELECT C.cust_id AS [Customer ID], C.first_name + ' ' + C.last_name AS [Customer Name], C.email AS [Email], C.phone_no AS [Phone no],
       SA.full_address AS [Address], SA.city AS [City], SA.province AS [Province], SA.zip_code AS [Zip code], SA.landmark AS [Landmark]
FROM Customer AS C
JOIN ShippingAddress AS SA
ON C.cust_id = SA.customer_id;

SELECT * FROM CustomerShippingDetails;

--this view calculates the average rating for each product and total  number of reviews for that product.
CREATE VIEW ProductAverageRating AS
SELECT P.p_id AS ProductID,  P.p_name AS ProductName,
       AVG(PR.rating) AS AverageRating,
       COUNT(PR.rev_id) AS NumberOfReviews
FROM Product AS P
JOIN ProductReview AS PR
ON P.p_id = PR.p_id
WHERE PR.status = 'visible'
GROUP BY P.p_id, P.p_name;

SELECT * FROM ProductAverageRating;

--this views shows that which product sold the most
CREATE VIEW BestSellingProducts AS
SELECT P.p_name AS [Product Name],V.color AS [Variant Color], SUM(OC.quantity) AS [Total Sold],SUM(OC.quantity * OC.unit_price) AS [Total Revenue]
FROM OrderCartItem OC
JOIN ProductVariant V ON OC.v_id = V.v_id
JOIN Product P ON V.p_id = P.p_id
GROUP BY P.p_name, V.color

SELECT * FROM BestSellingProducts
ORDER BY [Total Sold] DESC;                    --SInce we can't sort in the view so we can sort it by the total revenue with the view call

--this view shows all of the pending orders
CREATE VIEW PendingOrders AS
SELECT O.order_no AS [Order ID],O.order_date AS [Order Date],C.first_name + ' ' + C.last_name AS [Customer Name],S.city AS [City],S.full_address AS [Full address],
    SUM(OCI.unit_price * OCI.quantity) AS [Total amount]
FROM Customer_Order O JOIN Customer C ON O.customer_id = C.cust_id
JOIN ShippingAddress S ON O.shipping_address_id = S.s_id
JOIN OrderCartItem OCI ON O.order_no = OCI.order_no
WHERE O.order_status = 'pending'
GROUP BY O.order_no, O.order_date, C.first_name, C.last_name, S.city, S.full_address;

SELECT * FROM PendingOrders
