import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    @Published var isPro: Bool = false
    static let productId = "com.shimondeitel.vinelogapp.pro.monthly"

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                await self?.handle(result)
            }
        }
        Task { await self.refresh() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func purchase() async {
        do {
            let products = try await Product.products(for: [Self.productId])
            guard let product = products.first else { return }
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                await handle(verification)
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refresh()
    }

    func refresh() async {
        var owned = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == Self.productId {
                owned = true
            }
        }
        isPro = owned
    }

    private func handle(_ result: VerificationResult<Transaction>) async {
        if case .verified(let transaction) = result {
            if transaction.productID == Self.productId {
                isPro = true
            }
            await transaction.finish()
        }
    }
}
