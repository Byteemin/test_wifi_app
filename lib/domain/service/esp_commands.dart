class EspCommands {
  final List<List<int>> _commands = [
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00], // F1 (0x0400)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80], // F2 (0x0080)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00], // F3 (0x0010)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02], // F4 (0x0002)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00], // F5 (0x2000)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00], // F6 (0x4000)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00], // F7 (0x0800)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00], // F8 (0x0100)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04], // Меню (0x0004)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20], // Режим (0x0020)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00], // Ввод (0x8000)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00], // Отмена (0x1000)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00], // Архив (0x0200)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40], // F (0x0040)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01], // Вниз (0x0001)
  [0xFE, 0x08, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08], // Вверх (0x0008)
];

  List<List<int>> get commands => _commands;
}
