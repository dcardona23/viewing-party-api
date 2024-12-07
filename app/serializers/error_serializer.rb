class ErrorSerializer
  def self.format_error(error_message)
    {
      message: error_message.message,
      status: error_message.status_code
    }
  end

  def self.format_unprocessable(error_message, status_code)
    {
      message: error_message,
      status: status_code
    }
  end
end