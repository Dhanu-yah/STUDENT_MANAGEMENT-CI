from app import add_numbers, subtract_numbers

def test_addition():
    assert add_numbers(10, 20) == 30

def test_subtraction():
    assert subtract_numbers(20, 10) == 10

print("ALL TESTS PASSED")
