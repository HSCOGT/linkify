import 'package:linkify/linkify.dart';

/// For details on how this RegEx works, go to this link.
/// https://regex101.com/r/HDegq4/1
final _userTagRegex = RegExp(
  r'^(.*?)(?<![a-zA-Z0-9_À-ú@])@([a-zA-Z0-9_À-ú@]+(?:[.!][a-zA-Z0-9_À-ú@]+)*)',
  caseSensitive: false,
  dotAll: true,
);

class UserTagLinkifier extends Linkifier {
  const UserTagLinkifier();

  @override
  List<LinkifyElement> parse(elements, options) {
    final list = <LinkifyElement>[];

    elements.forEach((element) {
      if (element is TextElement) {
        final match = _userTagRegex.firstMatch(element.text);

        if (match == null) {
          list.add(element);
        } else {
          final text = element.text.replaceFirst(match.group(0)!, '');

          if (match.group(1)?.isNotEmpty == true) {
            list.add(TextElement(match.group(1)!));
          }

          if (match.group(2)?.isNotEmpty == true) {
            list.add(UserTagElement('@${match.group(2)!}'));
          }

          if (text.isNotEmpty) {
            list.addAll(parse([TextElement(text)], options));
          }
        }
      } else {
        list.add(element);
      }
    });

    return list;
  }
}

/// Represents an element containing an user tag
class UserTagElement extends LinkableElement {
  final String userTag;

  UserTagElement(this.userTag) : super(userTag, userTag);

  @override
  String toString() {
    return "UserTagElement: '$userTag' ($text)";
  }

  @override
  bool operator ==(other) => equals(other);

  @override
  bool equals(other) =>
      other is UserTagElement &&
      super.equals(other) &&
      other.userTag == userTag;
}
