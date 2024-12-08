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

  def self.format_not_found(exception)
    {
      message: exception.message,
      status: "404"
    }
  end
end