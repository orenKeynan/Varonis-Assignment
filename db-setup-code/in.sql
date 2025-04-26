-- Create the restaurants table
CREATE TABLE restaurants (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    style NVARCHAR(50) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    openHour NVARCHAR(5) NOT NULL,
    closeHour NVARCHAR(5) NOT NULL,
    vegetarian BIT NOT NULL DEFAULT 0,
    delivery BIT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);

-- Create index on commonly searched fields
CREATE INDEX idx_restaurant_style ON restaurants (style);
CREATE INDEX idx_restaurant_vegetarian ON restaurants (vegetarian);
CREATE INDEX idx_restaurant_delivery ON restaurants (delivery);

-- Create the api_logs table for secure request logging
CREATE TABLE api_logs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    timestamp DATETIME NOT NULL,
    request_data NVARCHAR(MAX) NOT NULL,
    response_data NVARCHAR(MAX) NOT NULL,
    ip_address NVARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);

-- Insert sample restaurant data
INSERT INTO restaurants (name, style, address, openHour, closeHour, vegetarian, delivery)
VALUES
('Pizza Hut', 'Italian', 'wherever street 99, somewhere', '09:00', '23:00', 0, 1),
('Green Garden', 'Korean', '123 Seoul St, Korea City', '11:00', '22:00', 1, 0),
('Le Bistro', 'French', '45 Rue de Paris, Paris', '12:00', '22:30', 0, 0),
('Veggie Paradise', 'Indian', '78 Spice Ave, Mumbai', '10:00', '21:00', 1, 1),
('Sushi Master', 'Japanese', '22 Tokyo Rd, Tokyo', '11:30', '23:00', 0, 1),
('Farm to Table', 'American', '10 Organic Ln, Portland', '07:00', '20:00', 1, 0),
('Taco Fiesta', 'Mexican', '55 Salsa St, Mexico City', '10:00', '22:00', 0, 1),
('Thai Fusion', 'Thai', '33 Bamboo Dr, Bangkok', '11:00', '23:30', 1, 1),
('Mamas Kitchen', 'Italian', '99 Pasta Rd, Rome', '12:00', '22:00', 0, 0),
('Falafel House', 'Mediterranean', '44 Olive St, Athens', '10:30', '21:30', 1, 1);