package util

import (
	"testing"
)

//TestAddNum use to test AddNum function
func TestAddNum(t *testing.T) {
	result := AddNum(3, 5)
	if result != 8 {
		t.Error("Expected 8 but found:", result)
	}
}

//BenchmarkHello bench mark for AddNum func
func BenchmarkAddNum(b *testing.B) {
	for i := 0; i < b.N; i++ {
		AddNum(3, 5)
	}
}
