import 'dart:typed_data';

import 'package:delivery_app/auth/blocs/auth_bloc.dart';
import 'package:delivery_app/settings/data/settings_repository.dart';
import 'package:delivery_app/settings/profile_picture/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().userId;
    final settingsRepository = context.read<SettingsRepository>();

    return FutureBuilder(
      future: settingsRepository.getProfileImage(userId: userId),
      builder: (context, snapshot) {
        final data = snapshot.data;
        return GestureDetector(
          onTap: snapshot.connectionState == ConnectionState.done || data != null
              ? () async {
                  final imageFile = await ImageUtils.pickImage();

                  if (userId == null) return;

                  if (imageFile != null) {
                    final List<int> imageBytes = await imageFile.readAsBytes();

                    final image = Uint8List.fromList(imageBytes);

                    await settingsRepository.setProfileImage(
                      imageBytes: image,
                      userId: userId,
                    );
                  }
                  setState(() {});
                }
              : null,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey,
                backgroundImage: snapshot.hasError
                    ? null
                    : snapshot.connectionState == ConnectionState.done
                        ? data == null
                            ? null
                            : NetworkImage(data as String)
                        : null,
                child: snapshot.hasError
                    ? const Icon(Icons.warning, size: 70)
                    : snapshot.connectionState == ConnectionState.done
                        ? data == null
                            ? const Icon(Icons.person, size: 70)
                            : null
                        : const CircularProgressIndicator(),
              ),
              CircleAvatar(
                backgroundColor: snapshot.connectionState == ConnectionState.done || data != null ? Colors.deepPurpleAccent : Colors.grey,
                radius: 25,
                child: const Icon(Icons.edit, size: 25),
              ),
            ],
          ),
        );
      },
    );
  }
}
