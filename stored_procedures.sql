-- Stored Procedures & Views

set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table users (
uname varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date default null,
primary key (uname)
) engine = innodb;

create table customers (
uname varchar(40) not null,
rating integer not null,
credit integer not null,
primary key (uname)
) engine = innodb;

create table employees (
uname varchar(40) not null,
taxID varchar(40) not null,
service integer not null,
salary integer not null,
primary key (uname),
unique key (taxID)
) engine = innodb;

create table drone_pilots (
uname varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (uname),
unique key (licenseID)
) engine = innodb;

create table store_workers (
uname varchar(40) not null,
primary key (uname)
) engine = innodb;

create table products (
barcode varchar(40) not null,
pname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table orders (
orderID varchar(40) not null,
sold_on date not null,
purchased_by varchar(40) not null,
carrier_store varchar(40) not null,
carrier_tag integer not null,
primary key (orderID)
) engine = innodb;

create table stores (
storeID varchar(40) not null,
sname varchar(100) not null,
revenue integer not null,
manager varchar(40) not null,
primary key (storeID)
) engine = innodb;

create table drones (
storeID varchar(40) not null,
droneTag integer not null,
capacity integer not null,
remaining_trips integer not null,
pilot varchar(40) not null,
primary key (storeID, droneTag)
) engine = innodb;

create table order_lines (
orderID varchar(40) not null,
barcode varchar(40) not null,
price integer not null,
quantity integer not null,
primary key (orderID, barcode)
) engine = innodb;

create table employed_workers (
storeID varchar(40) not null,
uname varchar(40) not null,
primary key (storeID, uname)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table customers add constraint fk1 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table employees add constraint fk2 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table store_workers add constraint fk4 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag)
	on update cascade on delete cascade;
alter table stores add constraint fk11 foreign key (manager) references store_workers (uname)
	on update cascade on delete cascade;
alter table drones add constraint fk5 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname)
	on update cascade on delete cascade;
alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID)
	on update cascade on delete cascade;
alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname)
	on update cascade on delete cascade;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

insert into customers values
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

insert into employees values
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

insert into store_workers values
('eross10'),
('hstark16'),
('echarles19');

insert into stores values
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

insert into employed_workers values
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

insert into drone_pilots values
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

insert into drones values
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

insert into products values
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

insert into orders values
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

insert into order_lines values
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------

-- add customer
delimiter // 
create procedure add_customer
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_rating integer, in ip_credit integer)
sp_main: begin
	declare uname_exists int default 0;
    
    if ip_uname is not null and ip_first_name is not null and ip_last_name is not null
       and ip_address is not null and ip_birthdate is not null and ip_rating is not null
       and ip_credit is not null then
       
		select count(*) into uname_exists from users where uname = ip_uname;

		if uname_exists = 0 then
			insert into users (uname, first_name, last_name, address, birthdate)
			values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
			
			insert into customers (uname, rating, credit) values (ip_uname, ip_rating, ip_credit);
		end if;
	end if;
end //
delimiter ;

-- add drone pilot
delimiter // 
create procedure add_drone_pilot
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer, 
    in ip_salary integer, in ip_licenseID varchar(40),
    in ip_experience integer)
sp_main: begin
    declare uname_exists int;
    declare taxID_exists int;
    declare licenseID_exists int;
    
    if ip_uname is not null and 
	   ip_first_name is not null and 
	   ip_last_name is not null and 
	   ip_address is not null and 
	   ip_birthdate is not null and 
	   ip_taxID is not null and 
	   ip_service is not null and 
	   ip_salary is not null and 
	   ip_licenseID is not null and 
	   ip_experience is not null then
    
		select count(*) into uname_exists from users where uname = ip_uname;
		select count(*) into taxID_exists from employees where taxID = ip_taxID;
		select count(*) into licenseID_exists from drone_pilots where licenseID = ip_licenseID;

		if uname_exists = 0 and taxID_exists = 0 and licenseID_exists = 0 then
			insert into users (uname, first_name, last_name, address, birthdate)
			values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);

			insert into employees (uname, taxID, service, salary)
			values (ip_uname, ip_taxID, ip_service, ip_salary);
			
			insert into drone_pilots (uname, licenseID, experience)
			values (ip_uname, ip_licenseID, ip_experience);
		end if;
	end if;
end //
delimiter ;

-- add product
delimiter // 
create procedure add_product
	(in ip_barcode varchar(40), in ip_pname varchar(100),
    in ip_weight integer)
sp_main: begin
    declare barcode_exists int;

	if ip_barcode is not null and 
		ip_pname is not null and
        ip_weight is not null then 
        
		select count(*) into barcode_exists 
		from products 
		where barcode = ip_barcode;

		if barcode_exists = 0 then
			insert into products (barcode, pname, weight)
			values (ip_barcode, ip_pname, ip_weight);
		end if;
	end if;
end //
delimiter ;

-- add drone
delimiter // 
create procedure add_drone
	(in ip_storeID varchar(40), in ip_droneTag integer,
    in ip_capacity integer, in ip_remaining_trips integer,
    in ip_pilot varchar(40))
sp_main: begin
    declare store_exists int;
    declare tag_exists int;
    declare pilot_free int;
    
	if ip_storeID is not null and 
		ip_droneTag is not null and
        ip_capacity is not null and 
        ip_remaining_trips is not null and 
		ip_pilot is not null then
        
		select count(*) into store_exists 
		from stores 
		where storeID = ip_storeID;

		select count(*) into tag_exists 
		from drones 
		where storeID = ip_storeID and droneTag = ip_droneTag;

		select count(*) into pilot_free 
		from drones 
		where pilot = ip_pilot;

		if store_exists > 0 and tag_exists = 0 and pilot_free = 0 then
			insert into drones (storeID, droneTag, capacity, remaining_trips, pilot)
			values (ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot);
		end if;
	end if;
end //
delimiter ;

-- increase customer credits
delimiter // 
create procedure increase_customer_credits
	(in ip_uname varchar(40), in ip_money integer)
sp_main: begin
	if ip_uname is not null and 
		ip_money is not null then
		if ip_money >= 0 then
			update customers
			set credit = credit + ip_money
			where uname = ip_uname;
		end if;
	end if;
end //
delimiter ;

-- swap drone control
delimiter // 
create procedure swap_drone_control
	(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40))
sp_main: begin
	declare ip_count int;
    declare op_drone_count int;
    declare ip_drone_count int;
    
 	if ip_incoming_pilot is not null and 
		ip_outgoing_pilot is not null then   
        
		select count(*) into ip_count from drone_pilots where uname=ip_incoming_pilot;
		select count(*) into ip_drone_count from drones where pilot=ip_incoming_pilot;
		select count(*) into op_drone_count from drones where pilot=ip_outgoing_pilot;
		
		if ip_count > 0 and ip_drone_count = 0 and op_drone_count > 0 then
			update drones
			set pilot = ip_incoming_pilot
			where pilot = ip_outgoing_pilot;
		end if;
	end if;
end //
delimiter ;

-- repair and refuel a drone
delimiter // 
create procedure repair_refuel_drone
	(in ip_drone_store varchar(40), in ip_drone_tag integer,
    in ip_refueled_trips integer)
sp_main: begin
 	if ip_drone_store is not null and 
		ip_drone_tag is not null and
        ip_refueled_trips is not null then
        
		if ip_refueled_trips >= 0 then
			update drones
			set remaining_trips = remaining_trips + ip_refueled_trips
			where storeID = ip_drone_store and droneTag = ip_drone_tag;
		end if;
	end if;
end //
delimiter ;

-- begin order
delimiter // 
create procedure begin_order
	(in ip_orderID varchar(40), in ip_sold_on date,
    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40),
    in ip_carrier_tag integer, in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
    declare v_customer_credit int;
    declare v_drone_capacity int;
    declare v_product_weight int;
	
	if ip_orderID is not null and 
	   ip_sold_on is not null and 
	   ip_purchased_by is not null and 
	   ip_carrier_store is not null and 
	   ip_carrier_tag is not null and 
	   ip_barcode is not null and 
	   ip_price is not null and 
	   ip_quantity is not null then
       
		select credit into v_customer_credit from customers where uname = ip_purchased_by;
		select capacity into v_drone_capacity from drones where storeID = ip_carrier_store and droneTag = ip_carrier_tag;
		select weight into v_product_weight from products where barcode = ip_barcode;

		if v_customer_credit is not null and v_drone_capacity is not null and v_product_weight is not null
			and ip_price >= 0 and ip_quantity > 0 
			and v_customer_credit >= (ip_price * ip_quantity)
			and (v_drone_capacity >= (v_product_weight * ip_quantity)) then

			insert into orders (orderID, sold_on, purchased_by, carrier_store, carrier_tag)
			values (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);

			insert into order_lines (orderID, barcode, price, quantity)
			values (ip_orderID, ip_barcode, ip_price, ip_quantity);
		end if;
	end if;
end //
delimiter ;

-- add order line
delimiter // 
create procedure add_order_line
	(in ip_orderID varchar(40), in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
    declare v_customer_credit int;
    declare v_drone_capacity int;
    declare v_product_weight int;
    declare v_total_weight_for_order int;
    declare v_order_exists int;
    declare v_line_exists int;
    declare v_allocated_credit int;
    declare v_new_order_line_cost int;
    
    if ip_orderID is not null and 
	   ip_barcode is not null and 
	   ip_price is not null and 
	   ip_quantity is not null then
		
		set v_new_order_line_cost = ip_price * ip_quantity;
			
		select count(*) into v_order_exists from orders where orderID = ip_orderID;
		select count(*) into v_line_exists from order_lines where orderID = ip_orderID and barcode = ip_barcode;
		
		-- Fetch necessary data
		select c.credit into v_customer_credit 
		from customers c 
		where uname = (select purchased_by from orders where orderID = ip_orderID);

		select ifnull(sum(ol.price * ol.quantity), 0) into v_allocated_credit
		from order_lines ol
		join orders o ON ol.orderID = o.orderID
		where o.purchased_by = (select purchased_by from orders where orderID = ip_orderID);


		select capacity into v_drone_capacity from drones d
		join orders o on d.storeID = o.carrier_store and d.droneTag = o.carrier_tag
		where o.orderID = ip_orderID;

		select weight into v_product_weight from products where barcode = ip_barcode;

		-- Calculate total weight for the order including the new line
		select sum(p.weight * ol.quantity) into v_total_weight_for_order
		from order_lines ol
		join products p on ol.barcode = p.barcode
		where ol.orderID = ip_orderID;

		-- Check if conditions are met
		if v_order_exists > 0 and v_line_exists = 0 and ip_price >= 0 and ip_quantity > 0
			and ((v_customer_credit - v_allocated_credit) >= v_new_order_line_cost)
			and (v_drone_capacity >= (v_total_weight_for_order + (v_product_weight * ip_quantity))) then
			
			-- Insert the new order line
			insert into order_lines (orderID, barcode, price, quantity)
			values (ip_orderID, ip_barcode, ip_price, ip_quantity);

		end if;
	end if;
end //
delimiter ;

-- deliver order
delimiter // 
create procedure deliver_order
	(in ip_orderID varchar(40))
sp_main: begin
    declare v_cost int default 0;
    declare v_droneID int;
    declare v_pilot varchar(40);
    declare v_remaining_trips int;
    declare v_customer_uname varchar(40);
    declare v_storeID varchar(40);
    
    if ip_orderID is not null then 
    
		select d.droneTag, d.remaining_trips, o.purchased_by, d.pilot, d.storeID
		into v_droneID, v_remaining_trips, v_customer_uname, v_pilot, v_storeID
		from orders o
		join drones d on o.carrier_store = d.storeID and o.carrier_tag = d.droneTag
		where o.orderID = ip_orderID;

		select sum(ol.price * ol.quantity) into v_cost
		from order_lines ol
		where ol.orderID = ip_orderID;

		if v_remaining_trips > 0 then
			update drones
			set remaining_trips = remaining_trips - 1
			where storeID = v_storeID and droneTag = v_droneID;

			update customers
			set rating = case 
							when v_cost > 25 then rating + 1
							else rating
						 end
			where uname = v_customer_uname;
			
			update stores
			set revenue = revenue + v_cost
			where storeID = v_storeID;

			update customers
			set credit = credit - v_cost
			where uname = v_customer_uname;
			
			update drone_pilots
			set experience = experience + 1
			where uname = v_pilot;

			delete from order_lines where orderID = ip_orderID;
			delete from orders where orderID = ip_orderID;
		end if;
	end if;
end //
delimiter ;

-- cancel an order
delimiter // 
create procedure cancel_order
	(in ip_orderID varchar(40))
sp_main: begin
	declare customer_uname varchar(40);
	if ip_orderID is not null then
    
		select purchased_by into customer_uname
		from orders
		where orderID = ip_orderID;

		if customer_uname is not null then
			update customers
			set rating = rating - 1
			where uname = customer_uname and rating > 0;
			
			delete from order_lines where orderID = ip_orderID;
			delete from orders where orderID = ip_orderID;
		end if;
	end if;
end //
delimiter ;

-- display persons distribution across roles
create or replace view role_distribution (category, total) as
-- replace this select query with your solution
select 'users' as category, count(*) as total from users
union all
select 'customers' as category, count(*) as total from customers
union all
select 'employees' as category, count(*) as total from employees
union all
select 'customer_employer_overlap' as category, count(*) as total from users u
    join customers c on u.uname = c.uname
    join employees e on u.uname = e.uname
union all
select 'drone_pilots' as category, count(*) as total from drone_pilots
union all
select 'store_workers' as category, count(*) as total from store_workers
union all
select 'other_employee_roles' as category, count(*) as total from employees e
    where not exists (select 1 from drone_pilots dp where dp.uname = e.uname)
    and not exists (select 1 from store_workers sw where sw.uname = e.uname);

-- display customer status and current credit and spending activity
create or replace view customer_credit_check (customer_name, rating, current_credit,
	credit_already_allocated) as
select 
    u.uname as customer_name,
    c.rating,
    c.credit as current_credit,
    ifnull(sum(ol.price * ol.quantity), 0) as credit_already_allocated
from 
    customers c
join 
    users u on c.uname = u.uname
left join 
    orders o on c.uname = o.purchased_by
left join 
    order_lines ol on o.orderID = ol.orderID
group by
    u.uname, c.rating, c.credit;
    
-- display drone status and current activity
create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot,
	total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as
select 
    d.storeID as drone_serves_store, 
    d.droneTag as drone_tag, 
    d.pilot, 
    d.capacity as total_weight_allowed, 
    ifnull(sum(p.weight * ol.quantity), 0) as current_weight,
    d.remaining_trips as deliveries_allowed,
    count(distinct o.orderID) as deliveries_in_progress
from 
    drones d
left join 
    orders o on d.storeID = o.carrier_store and d.droneTag = o.carrier_tag
left join 
    order_lines ol on o.orderID = ol.orderID
left join 
    products p on ol.barcode = p.barcode
group by
    d.storeID, d.droneTag, d.pilot, d.capacity;


-- display product status and current activity including most popular products
create or replace view most_popular_products (barcode, product_name, weight, lowest_price,
	highest_price, lowest_quantity, highest_quantity, total_quantity) as
select 
    p.barcode, 
    p.pname as product_name, 
    p.weight, 
    min(ol.price) as lowest_price,
    max(ol.price) as highest_price, 
    coalesce(min(ol.quantity), 0) as lowest_quantity,
    coalesce(max(ol.quantity), 0) as highest_quantity,
    coalesce(sum(ol.quantity), 0) as total_quantity
from 
    products p
left join
    order_lines ol on p.barcode = ol.barcode
group by
    p.barcode, p.pname, p.weight;

-- display drone pilot status and current activity including experience
create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store,
	drone_tag, successful_deliveries, pending_deliveries) as
-- replace this select query with your solution
select 
    dp.uname as pilot, 
    dp.licenseID, 
    d.storeID as drone_serves_store, 
    d.droneTag as drone_tag,
    dp.experience as successful_deliveries, 
    coalesce(pd.pending_count, 0) as pending_deliveries
from 
    drone_pilots dp
left join
    drones d on dp.uname = d.pilot
left join (
    select 
        d.pilot, 
        count(*) as pending_count
    from 
        orders o
    join 
        drones d on o.carrier_store = d.storeID and o.carrier_tag = d.droneTag
    where 
        o.sold_on > curdate()
    group by
        d.pilot
    ) pd on dp.uname = pd.pilot;
    

-- display store revenue and activity
create or replace view store_sales_overview (store_id, sname, manager, revenue,
	incoming_revenue, incoming_orders) as

select 
    s.storeID as store_id,
    s.sname,
    s.manager,
    s.revenue,
    coalesce(sum(ol.price * ol.quantity), 0) as incoming_revenue,
    count(distinct o.orderID) as incoming_orders
from 
    stores s
left join 
    drones d on s.storeID = d.storeID
left join 
    orders o on d.storeID = o.carrier_store and d.droneTag = o.carrier_tag
left join 
    order_lines ol on o.orderID = ol.orderID
where 
    o.sold_on >= curdate()
group by
    s.storeID;
    
-- display the current orders that are being placed/in progress
create or replace view orders_in_progress (orderID, cost, num_products, payload,
	contents) as
select orderID, sum(price * quantity) as cost, count(*) as num_products,
sum(weight * quantity) as payload, group_concat(pname) as contents
from orders join order_lines using (orderID)
join products on order_lines.barcode = products.barcode group by orderID;

-- remove customer
delimiter // 
create procedure remove_customer
	(in ip_uname varchar(40))
sp_main: begin
    declare order_count int;
    declare is_employee int;
	
    if ip_uname is not null then
		select count(*) into order_count
		from orders
		where purchased_by = ip_uname;

		select count(*) into is_employee
		from employees
		where uname = ip_uname;

		if order_count = 0 and is_employee = 0 then
			delete from customers where uname = ip_uname;
			delete from users where uname = ip_uname;
		elseif order_count = 0 and is_employee > 0 then
			-- Only remove from customers table if the user is also an employee
			delete from customers where uname = ip_uname;
		end if;
	end if;
end //
delimiter ;

-- remove drone pilot
delimiter // 
create procedure remove_drone_pilot
	(in ip_uname varchar(40))
sp_main: begin
	declare pilot_drone_count int;
    declare pilot_cust_count int;
	
    if ip_uname is not null then
    
		select count(*) into pilot_drone_count from drones where pilot=ip_uname;
		select count(*) into pilot_cust_count from customers where uname=ip_uname;
		if pilot_drone_count = 0 and pilot_cust_count > 0 then
			delete from employees where uname=ip_uname;
		end if;
		if pilot_drone_count = 0 and pilot_cust_count = 0 then
			delete from users where uname=ip_uname;
		end if;
	end if;
end //
delimiter ;

-- remove product
delimiter // 
create procedure remove_product
	(in ip_barcode varchar(40))
sp_main: begin
    declare v_order_count int;

	if ip_barcode is not null then 
    
		select count(*) into v_order_count 
		from order_lines ol
		join orders o on ol.orderID = o.orderID
		where ol.barcode = ip_barcode and o.sold_on >= curdate(); 

		if v_order_count = 0 then
			delete from products 
			where barcode = ip_barcode;
		end if;
	end if;
end //
delimiter ;

-- remove drone
delimiter // 
create procedure remove_drone
	(in ip_storeID varchar(40), in ip_droneTag integer)
sp_main: begin
    declare v_order_count int;
	
    if ip_storeID is not null and
		ip_droneTag is not null then
        
		select count(*) into v_order_count 
		from orders 
		where carrier_store = ip_storeID and carrier_tag = ip_droneTag 
		and sold_on >= curdate();
		
		if v_order_count = 0 then
			delete from drones 
			where storeID = ip_storeID and droneTag = ip_droneTag;
		end if;
	end if;
end //
delimiter ;
