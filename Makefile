CARGO=RUSTFLAGS='-A deprecated' cargo

.PHONY: debug release test test-release bench fmt cov clean clippy security_audit

debug:
	$(CARGO) build --all
	scripts/release.sh x86 debug

release:
	$(CARGO) build --all  --release -j4
	scripts/release.sh x86 release

aarch64_debug:
	$(CARGO) build --all --target aarch64-unknown-linux-gnu
	scripts/release.sh aarch64 debug

aarch64_release:
	$(CARGO) build --all  --release --target aarch64-unknown-linux-gnu
	scripts/release.sh aarch64 release

test:
	RUST_BACKTRACE=full $(CARGO) test --all 2>&1

test-release:
	RUST_BACKTRACE=full $(CARGO) test --release --all

bench:
	-rm target/bench.log
	cargo bench --all --no-run |tee target/bench.log
	cargo bench --all --jobs 1 |tee -a target/bench.log

fmt:
	cargo fmt --all -- --check

cov:
	cargo cov test --all
	cargo cov report --open


clean:
	rm -rf target/debug/
	rm -rf target/release/

clippy:
	$(CARGO) clippy --all

# use cargo-audit to audit Cargo.lock for crates with security vulnerabilities
# expecting to see "Success No vulnerable packages found"
security_audit:
	scripts/security_audit.sh
