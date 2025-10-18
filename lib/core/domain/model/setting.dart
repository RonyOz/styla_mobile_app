class Setting {
  final bool notification;
  final bool sound;
  final bool disturb;
  final bool vibration;
  final bool reminders;

  const Setting({
    required this.notification,
    required this.sound,
    required this.disturb,
    required this.vibration,
    required this.reminders,
  });

  factory Setting.empty() {
    return Setting(
      notification: false,
      sound: false,
      disturb: false,
      vibration: false,
      reminders: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification': notification,
      'sound': sound,
      'disturb': disturb,
      'vibration': vibration,
      'reminders': reminders,
    };
  }

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      notification: json['notification'] as bool,
      sound: json['sound'] as bool,
      disturb: json['disturb'] as bool,
      vibration: json['vibration'] as bool,
      reminders: json['reminders'] as bool,
    );
  }

  Setting copyWith({
    bool? notification,
    bool? sound,
    bool? disturb,
    bool? vibration,
    bool? reminders,
  }) {
    return Setting(
      notification: notification ?? this.notification,
      sound: sound ?? this.sound,
      disturb: disturb ?? this.disturb,
      vibration: vibration ?? this.vibration,
      reminders: reminders ?? this.reminders,
    );
  }

  @override
  String toString() {
    return 'Setting(notification: $notification, sound: $sound, disturb: $disturb, vibration: $vibration, reminders: $reminders)';
  }
}
