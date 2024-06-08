class EspCommands {
  final List<String> _commands = [
    '0x0400', // f1
    '0x0080', // f2
    '0x0010', // f3
    '0x0002', // f4
    '0x2000', // f5
    '0x4000', // f6
    '0x0800', // f7
    '0x0100', // f8
    '0x0004', // меню
    '0x0020', // режим
    '0x8000', // Ввод
    '0x1000', // Отмена
    '0x0200', // Архив
    '0x0040', // F
    '0x0001', // Вниз
    '0x0008', // Вверх
  ];

  get commands => _commands;
}
