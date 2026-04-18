-- create database Ecommerce_management_system; 	



 --  Temporary Table


create table temp_orders (                    -- eita r porerta workbench e lage na. bakigulay lage kina ami jani na. tai raikha disi.
    row_num int auto_increment primary key,
    order_id       INT,
    customer_name  varchar(100),
    product_name   varchar(150),
    category       varchar(80),
    quantity       int,
    unit_price     decimal(10,2),
    total_price   DECIMAL(10,2), 
    order_date     date
);


-- Import CSV into the Temp Table




LOAD DATA INFILE 'C:/ecommerce_dataset_20000_rows.csv'
INTO TABLE temp_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, customer_name, product_name, category, quantity, unit_price, total_price, order_date);       -- file e category r naam gula ignore kore just

                                         -- test drive
select * from temp_orders limit 10;


                                         -- category table 
create table Categories (
    category_id   int primary key auto_increment,
    category_name varchar(80) not null unique
);

insert into Categories (category_name)
select distinct category
from temp_orders
where category is not null;

                                                 -- Insert Unique Customers into Customers Table

create table Customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    full_name     varchar(100) not null unique,
    phone         varchar(20),
    address       text,
    created_at    date default (current_date)
);
insert into Customers (full_name)
select distinct customer_name
from temp_orders
where customer_name is not null;



                                            -- products table

create table Products (
    product_id    int primary key auto_increment,
    product_name  varchar(150) not null unique,
    category_id    int not null,
    price         decimal(10, 2) not null,
    stock_qty     int default 0,
    description   text,
	foreign key (category_id) references Categories(category_id)
     );
     
insert into Products (product_name, category_id, price)
select distinct t.product_name, 
				c.category_id,
				t.unit_price
from temp_orders t
join Categories c on c.category_name = t.category;



                                       -- orders Table

create table Orders (
    order_id      int primary key,
    customer_id  int not null,
    order_date    date not null,
    status        varchar(50) default 'Completed',
    foreign key (customer_id) references Customers(customer_id)
);

insert into Orders (order_id,customer_id, order_date, status)
select
    t.order_id,
    c.customer_id,    -- eitay customer id khuja hoitese. join maira table r csv file match koira id nise eikhane just.
    t.order_date,
    'Completed'
from temp_orders t
join Customers c on c.full_name = t.customer_name;


                                  --  Order_Items Table


create table Order_Items (
    item_id       int primary key auto_increment,
    order_id      int not null,
    product_id    int not null,
    quantity      int not null,
    unit_price    decimal(10, 2) not null,
    foreign key (order_id) references Orders(order_id),
    foreign key (product_id) references Products(product_id)
);

insert into Order_Items (order_id, product_id, quantity, unit_price)
select
	t.order_id,
    p.product_id,
    t.quantity,
    t.unit_price
from temp_orders t
join products p on p.product_name = t.product_name;

                                           -- Payment table

create table Payments (
    payment_id      int primary key auto_increment,
    order_id        int not null,
    payment_date    date,
    amount          decimal(10, 2),
    payment_method  varchar(50),
    payment_status  varchar(50) default 'Unpaid',
    foreign key (order_id) references Orders(order_id)
);


                                           -- Reviews table


create table Reviews (
    review_id     int primary key auto_increment,
    customer_id   int not null,
    product_id    int not null,
    rating        int check (rating BETWEEN 1 AND 5),
    comment       text,
    review_date   date,
    foreign key (customer_id) references Customers(customer_id),
    foreign key (product_id) references Products(product_id)
);


                                              -- Cart table


create table Cart (
    cart_id int primary key auto_increment,
    customer_id int,
    product_id int,
    quantity int,
    foreign key (customer_id) references Customers(customer_id),
    foreign key (product_id) references Products(product_id)
);

                                    -- coupon table


create table Coupons (
    coupon_id int primary key auto_increment,
    code varchar(50) unique,
    discount_percent int check (discount_percent between 1 and 100),
    expiry_date date
);

                                    -- TRIGGER(stock r obostha r jonno)

delimiter $$
create trigger update_stock_after_order
after insert on Order_Items
for each row
begin
update Products
set stock_qty = stock_qty - new.quantity
where product_id = new.product_id;
end$$
delimiter ;


                                        --  Data check

-- row count
select COUNT(*) as total_customers from Customers;   
SELECT COUNT(*) AS total_categories FROM Categories;
select COUNT(*) as total_products from Products;   
select COUNT(*) as total_orders  from Orders;      
select COUNT(*) as total_items from Order_Items; 

-- 59,3,5,20000,20000 egula ashbe ck dile. 
                   -- Top selling product  
select 
    p.product_name,
    SUM(oi.quantity) as total_sold
from Order_Items oi
join Products p on p.product_id = oi.product_id
group by p.product_name
order by  total_sold desc
limit 5;

                   
                   -- Total revenue
 
select sum(oi.quantity * oi.unit_price) as total_revenue
from Order_items oi;
                  -- Monthly revenue
select 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * oi.unit_price) AS revenue
from Orders o
join Order_Items oi on o.order_id = oi.order_id
group by month
order by month;

					-- Most active customer
select 
    c.full_name,
    COUNT(o.order_id) as total_orders
from Customers c
join Orders o on c.customer_id = o.customer_id
group by c.full_name
order by total_orders desc
limit 5;

                     -- Purchase history
select 
    c.full_name,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    o.order_date
from Customers c
join Orders o on c.customer_id = o.customer_id
join Order_Items oi on o.order_id = oi.order_id
join Products p on p.product_id = oi.product_id
order by c.full_name;

                   -- category wise sale
select 
    c.category_name,
    SUM(oi.quantity) as total_items_sold
from Order_Items oi
join Products p on p.product_id = oi.product_id
join Categories c on p.category_id = c.category_id
group by c.category_name;     



-- Drop Table

DROP TABLE temp_orders;





