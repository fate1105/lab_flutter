class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String culture; // 'pizza', 'chinese', 'mexican', 'indian', 'beverages', 'desserts', 'ice_cream'

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.culture,
  });
}

// Dữ liệu mẫu sử dụng hoàn toàn các assets cục bộ do người dùng cung cấp
final List<FoodItem> mockFoodItems = [
  // --- PIZZA & MÓN Ý (pizza) ---
  FoodItem(
    id: 'we_pizza_margherita',
    name: 'Pizza Margherita Truyền Thống',
    description: 'Pizza Ý cổ điển với đế mỏng giòn, lớp sốt cà chua đậm đà, phô mai Mozzarella tươi dẻo dai béo ngậy và lá húng quế thơm mát.',
    price: 150000,
    imageUrl: 'assets/images/pizza.png',
    culture: 'pizza',
  ),
  FoodItem(
    id: 'we_pizza_classic',
    name: 'Pizza Thập Cẩm Phô Mai',
    description: 'Sự hòa quyện tuyệt hảo giữa giăm bông, xúc xích băm, nấm tươi, ớt chuông, phủ gấp đôi lớp phô mai Mozzarella thơm béo.',
    price: 175000,
    imageUrl: 'assets/images/pizza (1).png',
    culture: 'pizza',
  ),

  // --- TRUNG HOA (chinese) ---
  FoodItem(
    id: 'cn_suicao',
    name: 'Sủi Cảo Nhân Thịt Hấp',
    description: 'Món sủi cảo Trung Hoa truyền thống với vỏ bánh mỏng dai mịn, ôm trọn nhân thịt heo tôm tươi và hẹ thơm, dùng kèm xốt tương đen sa tế.',
    price: 60000,
    imageUrl: 'assets/images/chinese.png',
    culture: 'chinese',
  ),

  // --- MEXICO (mexican) ---
  FoodItem(
    id: 'me_tacos',
    name: 'Tacos Bò Cay Mexico',
    description: 'Vỏ bánh ngô giòn rụm kẹp thịt bò xào sả cay nồng, xà lách giòn, hành tây, rắc phô mai bào kèm xốt salsa cà chua đỏ rực rỡ.',
    price: 85000,
    imageUrl: 'assets/images/mexican.png',
    culture: 'mexican',
  ),

  // --- ẤN ĐỘ (indian) ---
  FoodItem(
    id: 'in_biryani',
    name: 'Cơm Trộn Biryani Gà Ấn Độ',
    description: 'Cơm hạt dài Basmati thơm dẻo nấu cùng đùi gà mềm mọng tẩm ướp sữa chua, nghệ tây và hơn 15 loại thảo mộc Ấn Độ đặc trưng.',
    price: 110000,
    imageUrl: 'assets/images/biryani.png',
    culture: 'indian',
  ),
  FoodItem(
    id: 'in_tikka',
    name: 'Gà nướng Tikka Masala',
    description: 'Thịt đùi gà nướng lò đất tẩm ướp đậm đà, chan xốt cà chua riêu béo ngậy thơm nức mùi masala truyền thống.',
    price: 130000,
    imageUrl: 'assets/images/north-indian.png',
    culture: 'indian',
  ),

  // --- ĐỒ UỐNG (beverages) ---
  FoodItem(
    id: 'be_matcha',
    name: 'Trà Sữa Matcha Trân Châu',
    description: 'Sự kết hợp giữa bột matcha Nhật Bản nguyên chất thơm thanh mát, sữa tươi béo dịu và trân châu đen dẻo ngọt dai giòn thích thú.',
    price: 45000,
    imageUrl: 'assets/images/beverages.png',
    culture: 'beverages',
  ),
  FoodItem(
    id: 'be_smoothie',
    name: 'Sinh Tố Chuối Sữa Dừa',
    description: 'Chuối già chín thơm ngọt lịm xay nhuyễn cùng nước cốt dừa béo ngậy và đá bào mát lạnh sảng khoái ngày hè.',
    price: 35000,
    imageUrl: 'assets/images/banana.png',
    culture: 'beverages',
  ),

  // --- TRÁNG MIỆNG (desserts) ---
  FoodItem(
    id: 'de_donut',
    name: 'Bánh Donut Chocolate Phủ Cốm',
    description: 'Bánh vòng donut chiên vàng ruột xốp mềm, nhúng sốt sô-cô-la đặc sánh ngọt ngào và rắc kẹo cốm sắc màu sinh động.',
    price: 40000,
    imageUrl: 'assets/images/desserts.png',
    culture: 'desserts',
  ),

  // --- KEM (ice_cream) ---
  FoodItem(
    id: 'ic_strawberry',
    name: 'Kem Ly Dâu Tây Hạnh Nhân',
    description: 'Kem tươi vị dâu ngọt ngào mát lạnh kết hợp dâu quả tươi chua nhẹ, phủ hạt hạnh nhân lát rang giòn rụm cực đưa miệng.',
    price: 45000,
    imageUrl: 'assets/images/ice-creams.png',
    culture: 'ice_cream',
  ),
];
