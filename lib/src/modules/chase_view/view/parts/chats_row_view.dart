import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/show_chats_dialog.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatsViewRow extends StatelessWidget {
  const ChatsViewRow({
    Key? key,
    required this.chase,
  }) : super(key: key);

  final Chase chase;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Chats :",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    //     decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            ClipOval(
              child: Material(
                child: IconButton(
                  onPressed: () async {
                    await Future<void>.delayed(Duration(milliseconds: 100));
                    showChatsDialog(context, chase);
                  },
                  icon: Icon(
                    Icons.expand,
                  ),
                ),
              ),
            )
          ],
        ),
        ProviderStateBuilder<Channel>(
          watchThisProvider: chatChannelProvider(chase),
          logger: Logger("Chats Section"),
          builder: (channel) {
            final messages = channel.state?.messages;
            if (messages == null || messages.isEmpty)
              return GestureDetector(
                onTap: () {
                  showChatsDialog(context, chase);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No chats yet",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              );

            final lastMessage = channel.state!.messages.last;
            return TweenAnimationBuilder<Offset>(
              tween: Tween<Offset>(
                  begin: Offset(0, MediaQuery.of(context).size.height),
                  end: Offset.zero),
              curve: Curves.decelerate,
              duration: Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: value,
                  child: child,
                );
              },
              child: StreamChannel(
                channel: channel,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  onTap: () async {
                    await Future<void>.delayed(Duration(milliseconds: 100));
                    showChatsDialog(context, chase);
                  },
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        lastMessage.user!.image ?? defaultProfileURL),
                  ),
                  title: Text(
                    lastMessage.user!.name,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  subtitle: lastMessage.text != null
                      ? Text(
                          lastMessage.text!,
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: primaryColor.shade300,
                                  ),
                        )
                      : SizedBox.shrink(),
                ),
              ),
            );
          },
          loadingBuilder: () => CircularAdaptiveProgressIndicatorWithBg(),
        ),
        SizedBox(
          height: kItemsSpacingLargeConstant,
        ),
      ],
    );
  }
}
