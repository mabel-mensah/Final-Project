<?php
class RestaurantDatabase {
    private $host = "localhost";
    private $port = "3306";
    private $database = "restaurant_reservations";
    private $user = "root";
    private $password = "YourPassword";
    private $connection;

    public function __construct() {
        $this->connect();
    }

    private function connect() {
        $this->connection = new mysqli($this->host, $this->user, $this->password, $this->database, $this->port);
        if ($this->connection->connect_error) {
            die("Connection failed: " . $this->connection->connect_error);
        }
        echo "Successfully connected to the database";
    }

    public function addReservation($customerId, $reservationTime, $numberOfGuests, $specialRequests) {
        $stmt = $this->connection->prepare(
            "INSERT INTO reservations (customerId, reservationTime, numberOfGuests, specialRequests) VALUES (?, ?, ?, ?)"
        );
        $stmt->bind_param("isis", $customerId, $reservationTime, $numberOfGuests, $specialRequests);
        $stmt->execute();
        $stmt->close();
        echo "Reservation added successfully";
    }

    public function getAllReservations() {
        $result = $this->connection->query("SELECT * FROM reservations");
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function addCustomer($customerName, $contactInfo) {
        $stmt = $this->conn->prepare("INSERT INTO Customers (customerName, contactInfo) VALUES (?, ?)");
        $stmt->bind_param("ss", $customerName, $contactInfo);
        $stmt->execute();
        $stmt->close();
    }

    public function getCustomerPreferences($customerId) {
        $stmt = $this->conn->prepare("CALL getCustomerPreferences(?)");
        $stmt->bind_param("i", $customerId);
        $stmt->execute();
        $result = $stmt->get_result();
        $reservations = $result->fetch_all(MYSQLI_ASSOC);
        $stmt->close();
    return $reservations;
    }

    public function addSpecialRequest($reservationId, $requests) {
        $stmt = $this->conn->prepare("CALL addSpecialRequest(?, ?)");
        $stmt->bind_param("is", $reservationId, $requests);
        $stmt->execute();
        $stmt->close();
    }
}
?>
