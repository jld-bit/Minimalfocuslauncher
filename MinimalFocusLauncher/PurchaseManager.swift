import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    @Published private(set) var hasPremiumThemes: Bool = false
    @Published private(set) var availableProducts: [Product] = []

    private let premiumProductID = "com.minimalfocuslauncher.premiumthemes"

    init() {
        Task {
            await loadProducts()
            await refreshEntitlements()
        }
    }

    func loadProducts() async {
        do {
            availableProducts = try await Product.products(for: [premiumProductID])
        } catch {
            availableProducts = []
        }
    }

    func buyPremiumThemes() async {
        guard let product = availableProducts.first(where: { $0.id == premiumProductID }) else { return }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified:
                    hasPremiumThemes = true
                case .unverified:
                    hasPremiumThemes = false
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            // Keep state unchanged on error.
        }
    }

    func refreshEntitlements() async {
        hasPremiumThemes = false

        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            if transaction.productID == premiumProductID {
                hasPremiumThemes = true
            }
        }
    }
}
