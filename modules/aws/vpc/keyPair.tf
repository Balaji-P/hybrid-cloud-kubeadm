resource "aws_key_pair" "vpc_one_deployer" {
  key_name   = "dlos-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRPjE9xyM6rMakE16M5qRpl/cVJ2q+H453v4fC1oYDSxRumDerYTkNpedYI+qdLr+hIHv92CPtBDW84z7rF8ctGg7vKdWxk2AYxLFTtmS7r5oO2WE7Tx4ZGa8rVjzm94Jsxeblcz4v/9GDWX935mLXHyhgKr6SS8Nq/D+tgzoY8ta2Q/ZXpzLEM+uw23uPkJ+v1X8+ZyGX9oha9A8XM1vSLNmHD+A+jM0wiFyPS3MR1CWistJM6wJJo/EqigDran8P4y6KK19NP9YlRiK2pY/C5RmD4Q9pA/hZ6E+CcM1S2+o01QCmTzLtsQw7sspS0HgVJCyVp164A3psFPvjzf2f delhivery@DV-LT-N-017992.local"
}

resource "aws_key_pair" "vpc_two_deployer" {
  provider = "aws.ohio"
  key_name   = "dlos-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRPjE9xyM6rMakE16M5qRpl/cVJ2q+H453v4fC1oYDSxRumDerYTkNpedYI+qdLr+hIHv92CPtBDW84z7rF8ctGg7vKdWxk2AYxLFTtmS7r5oO2WE7Tx4ZGa8rVjzm94Jsxeblcz4v/9GDWX935mLXHyhgKr6SS8Nq/D+tgzoY8ta2Q/ZXpzLEM+uw23uPkJ+v1X8+ZyGX9oha9A8XM1vSLNmHD+A+jM0wiFyPS3MR1CWistJM6wJJo/EqigDran8P4y6KK19NP9YlRiK2pY/C5RmD4Q9pA/hZ6E+CcM1S2+o01QCmTzLtsQw7sspS0HgVJCyVp164A3psFPvjzf2f delhivery@DV-LT-N-017992.local"
}