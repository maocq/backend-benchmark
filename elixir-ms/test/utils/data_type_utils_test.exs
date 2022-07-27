defmodule ElixirMs.Utils.DataTypeUtilsTest do
  alias ElixirMs.Utils.DataTypeUtils
  alias ElixirMs.Model.Error

  use ExUnit.Case

  test "should parse list" do
    input = [
      {"X-Forwarded-For3", "1.1.1.1, 2.2.2.2"},
      {"X-Forwarded-For", "1.1.1.1, 2.2.2.2"},
      {"X-Forwarded-For2", "1.1.1.1, 2.2.2.2"},
      %{any: "ok"}
    ]
    out = DataTypeUtils.extract_header(input, "X-Forwarded-For")
    assert out == {:ok, "1.1.1.1, 2.2.2.2"}
  end

  test "should fail when header not found" do
    input = [
      {"X-Forwarded-For3", "1.1.1.1, 2.2.2.2"},
      {"X-Forwarded-For", "1.1.1.1, 2.2.2.2"},
      {"X-Forwarded-For2", "1.1.1.1, 2.2.2.2"},
      %{any: "ok"}
    ]
    out = DataTypeUtils.extract_header(input, "header")
    assert out == {:error, :not_found}
  end

  test "should fail when data is not a list" do
    input = "Not a list"
    out = DataTypeUtils.extract_header(input, "name")
    assert out == {:error, "headers is not a list when finding \"name\": \"Not a list\""}
  end

  test "should normalize when data is a structure" do
    struct = %Error{error: "Error", message: "error"}
    model = DataTypeUtils.normalize(struct)
    assert struct == model
  end

  test "should normalize when data is list" do
    list = [1, 2, 3, 4, 5]
    value = DataTypeUtils.normalize(list)
    assert list == value
  end

  test "should normalize value" do
    value = DataTypeUtils.normalize(2)
    assert value == 2
  end

  test "should decode string base64" do
    value = DataTypeUtils.base64_decode("Zm9vYmFy")
    assert value == "foobar"
  end

  test "should parse true boolean string to boolean" do
    # Arrange
    # Act
    res = DataTypeUtils.format("true", "boolean")
    # Assert
    assert res == true
  end

  test "should parse false boolean string to boolean" do
    # Arrange
    # Act
    res = DataTypeUtils.format("false", "boolean")
    # Assert
    assert res == false
  end

  test "should parse integer string to float" do
    # Arrange
    # Act
    res = DataTypeUtils.format("1", "number")
    # Assert
    assert res == 1
  end

  test "should parse float string to float" do
    # Arrange
    # Act
    res = DataTypeUtils.format("1.1", "number")
    # Assert
    assert res == 1.1
  end

  test "should return nil when is nor valid number" do
    # Arrange
    # Act
    res = DataTypeUtils.format("1.1.3", "number")
    # Assert
    assert res == nil
  end

  test "should return same value when not format is required" do
    # Arrange
    # Act
    res = DataTypeUtils.format(10, "number")
    # Assert
    assert res == 10
  end
end