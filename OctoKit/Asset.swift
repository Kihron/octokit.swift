//
//  Asset.swift
//  OctoKit
//
//  Created by Kihron on 4/25/25.
//

import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: model

public struct Asset: Codable {
    public let id: Int
    public let url: URL
    public let downloadUrl: URL
    public let nodeId: String
    public let name: String
    public let label: String
    public let state: State
    public let contentType: String
    public let size: Int
    public let downloadCount: Int
    public let createdAt: Date
    public let updatedAt: Date?
    public let uploader: User

    public init(id: Int,
                url: URL,
                downloadUrl: URL,
                nodeId: String,
                name: String,
                label: String,
                state: State,
                contentType: String,
                size: Int,
                downloadCount: Int,
                createdAt: Date,
                updatedAt: Date?,
                uploader: User) {
        self.id = id
        self.url = url
        self.downloadUrl = downloadUrl
        self.nodeId = nodeId
        self.name = name
        self.label = label
        self.state = state
        self.contentType = contentType
        self.size = size
        self.downloadCount = downloadCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.uploader = uploader
    }

    public enum State: String, Codable {
        case uploaded
        case open
    }

    enum CodingKeys: String, CodingKey {
        case id, url, name, label, state, size, uploader

        case downloadUrl = "browser_download_url"
        case nodeId = "node_id"
        case contentType = "content_type"
        case downloadCount = "download_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: request

public extension Octokit {
    /// Deletes an asset.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repo: The repository on which the asset needs to be deleted.
    ///   - assetId: The ID of the asset to delete.
    ///   - completion: Callback for the outcome of the deletion.
    @discardableResult
    func deleteAsset(owner: String,
                     repository: String,
                     assetId: Int,
                     completion: @escaping (_ response: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        let router = AssetRouter.deleteAsset(configuration, owner, repository, assetId)
        return router.load(session, completion: completion)
    }
}

// MARK: Router
enum AssetRouter: JSONPostRouter {
    case deleteAsset(Configuration, String, String, Int)

    var configuration: Configuration {
        switch self {
            case let .deleteAsset(config, _, _, _): return config
        }
    }

    var method: HTTPMethod {
        switch self {
            case .deleteAsset:
                return .DELETE
        }
    }

    var encoding: HTTPEncoding {
        switch self {
            case .deleteAsset:
                return .url
        }
    }

    var params: [String : Any] {
        switch self {
            case .deleteAsset:
                return [:]
        }
    }

    var path: String {
        switch self {
            case let .deleteAsset(_, owner, repo, assetId):
                return "/repos/\(owner)/\(repo)/releases/assets/\(assetId)"
        }
    }
}
