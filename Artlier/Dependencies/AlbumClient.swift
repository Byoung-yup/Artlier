//
//  AlbumClient.swift
//  Artlier
//
//  Created by 김병엽 on 2024/04/23.
//

import ComposableArchitecture
import FirebaseDatabase
import FirebaseStorage

struct AlbumClient {
    var createAlbum: @Sendable (_ album: Album, _ albumImageDatas: [Data]) async throws -> Album
    
    init(
        createAlbum: @escaping @Sendable (_ album: Album, _ albumImageDatas: [Data]) async throws -> Album
    ) {
        self.createAlbum = createAlbum
    }
}

extension AlbumClient: DependencyKey {
    
    static let dbRef = Database.database().reference()
    static let storageRef = Storage.storage().reference()
    
    static let liveValue: Self = Self(
        createAlbum: { (album, imageDatas) in
            do {
                let path = Constant.getPath(key: DBKey.Albums, path: album.id)
                
                var albumImageUrls: [String] = []
                
                for (index, data) in imageDatas.enumerated() {
                    let ref = storageRef.child(path + "/image\(index).jpeg")
                    _ = try await ref.putDataAsync(data)
                    let imageUrl = try await ref.downloadURL().absoluteString
                    
                    albumImageUrls.append(imageUrl)
                }
                
                var reAlbum: Album = .init(
                    id: album.id,
                    userId: album.userId,
                    nickname: album.nickname,
                    profileImageUrl: album.profileImageUrl,
                    title: album.title,
                    content: album.content,
                    date: album.date,
                    albumImageUrls: albumImageUrls
                )
                
                let encoded = try JSONEncoder().encode(reAlbum)
                let data = try JSONSerialization.jsonObject(with: encoded, options: .fragmentsAllowed)
                
                try await dbRef.child(path).setValue(data)
                return reAlbum
            } catch {
                print("error create album", error.localizedDescription)
                throw AppError.FirebaseError
            }
        }
    )
}

extension DependencyValues {
    var albumlient: AlbumClient {
        get { self[AlbumClient.self] }
        set { self[AlbumClient.self] = newValue }
    }
}
